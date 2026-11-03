"""Replay the typed-reference pilot on temporary copies of both draft.3 package sources."""
import argparse
import hashlib
from pathlib import Path
import shutil
import subprocess
import tempfile

import yaml

PROJECT = Path(__file__).resolve().parents[3]
CANDIDATE = PROJECT / "ontology/candidates/domain-v0.2.0-draft.3"


def exercise(selection, compiler, consumer, work):
    member = yaml.safe_load(selection.read_bytes())["packages"][0]
    package_bytes = (PROJECT / member["source"]).read_bytes()
    if hashlib.sha256(package_bytes).hexdigest() != member["source_sha256"]:
        raise ValueError(f"Source no longer matches {selection.name}")
    package = yaml.safe_load(package_bytes)
    fields = package["spec"]["classes"]["AddRepository"]["fields"]
    if set(fields) != {"repositoryId"} or fields["repositoryId"]["type"] != "string":
        raise ValueError("Expected the draft.3 string reference")
    del fields["repositoryId"]
    fields["repository"] = {"type": "ref", "target": "Repository", "required": True}
    package["metadata"]["version"] += ".refpilot"

    case = work / selection.stem
    case.mkdir()
    source = case / "package.yaml"
    source.write_text(yaml.safe_dump(package, sort_keys=False, allow_unicode=True))
    subprocess.run([compiler, "compile", source, "--target", "typescript", "--out", case / "generated"], check=True)
    shutil.copyfile(consumer, case / "membership.ts")
    subprocess.run([work / "node_modules/.bin/tsc", "--strict", "--exactOptionalPropertyTypes", "--noEmitOnError",
                    "--target", "ES2022", "--module", "Node16", "--moduleResolution", "Node16",
                    "--outDir", "js", "membership.ts"], cwd=case, check=True)
    subprocess.run(["node", case / "js/membership.js"], check=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ontologyc", required=True, type=Path)
    parser.add_argument("--ontology-checkout", required=True, type=Path)
    args = parser.parse_args()
    consumer = args.ontology_checkout / "Examples/repository-membership/membership.ts"
    with tempfile.TemporaryDirectory(prefix="gitview-ref-pilot-") as directory:
        work = Path(directory)
        for name in ("package.json", "package-lock.json"):
            shutil.copy(CANDIDATE / "operator" / name, work)
        subprocess.run(["npm", "ci", "--ignore-scripts", "--no-audit", "--no-fund"], cwd=work, check=True)
        for name in ("foundation-context.yaml", "composition-context.yaml"):
            exercise(CANDIDATE / name, args.ontologyc.resolve(), consumer, work)


if __name__ == "__main__":
    main()
