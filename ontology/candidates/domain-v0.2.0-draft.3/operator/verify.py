"""Check the package and exercise the same operator using each candidate's freshly generated SDK."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

import yaml

HERE = Path(__file__).resolve().parent
CANDIDATE = HERE.parent
PROJECT = CANDIDATE.parents[2]
PREVIOUS = CANDIDATE.parent / "domain-v0.2.0-draft.2"


def run(args, cwd=None, expected=0):
    result = subprocess.run(args, cwd=cwd, capture_output=True, text=True)
    if result.returncode != expected:
        raise RuntimeError(f"{args[0]} {args[1]} returned {result.returncode}: {result.stdout}{result.stderr}")
    return result.stdout


def configured_compiler(key):
    p = subprocess.run(["git", "-C", PROJECT, "config", "--get", key], text=True, capture_output=True)
    return p.stdout.strip() or None


def source(path):
    return yaml.safe_load(path.read_bytes())


def check_negative(compiler, package, path, code, field):
    path.write_text(yaml.safe_dump(package, sort_keys=False, allow_unicode=True))
    diagnostics = json.loads(run([compiler, "check", path, "--format", "json"], expected=1))
    if [(d["code"], d["path"]) for d in diagnostics] != [(code, field)]:
        raise ValueError(diagnostics)
    return {"code": code, "path": field}


def reproduce_subject(work, candidate_compiler, stable_compiler):
    previous = source(PREVIOUS / "domain-ontology-package.yaml")
    new = source(CANDIDATE / "domain-ontology-package.yaml")
    old_protocol = previous["spec"]["protocols"]["User"]
    del new["spec"]["classes"]["User"]
    new["spec"]["protocols"]["User"] = old_protocol
    path = work / "subject-control.yaml"
    control = {"protocol_in_new_subject": check_negative(
        candidate_compiler, new, path, "relation.subject.unresolved", "spec.relations.addsRepositoryTo.subject")}
    if stable_compiler:
        previous["spec"]["relations"]["operatorProbe"] = {"domain": "User", "range": "Project"}
        control["protocol_in_old_domain"] = check_negative(
            stable_compiler, previous, path, "relation.domain.unresolved", "spec.relations.operatorProbe.domain")
        del previous["spec"]["protocols"]["User"]
        previous["spec"]["classes"]["User"] = {"extends": "sg:DomainEntity", "description": "GitView operator."}
        path.write_text(yaml.safe_dump(previous, sort_keys=False))
        run([stable_compiler, "check", path])
        control["class_in_old_domain"] = "passed"
    return control


def exercise(selection_name, work, compiler):
    selection = source(CANDIDATE / selection_name)
    for member in selection["packages"]:
        for key in ("source", "ir"):
            if hashlib.sha256((PROJECT / member[key]).read_bytes()).hexdigest() != member[key + "_sha256"]:
                raise ValueError(f"Stale {key} pin for {member['id']}")
    project = selection["packages"][0]
    src = PROJECT / project["source"]
    sdk = work / selection_name.split("-")[0]
    sdk.mkdir()
    generated = sdk / "generated"
    run([compiler, "check", src])
    run([compiler, "compile", src, "--target", "typescript", "--out", generated])
    if (generated / "ontology.normalized.json").read_bytes() != (PROJECT / project["ir"]).read_bytes():
        raise ValueError(f"Stored IR differs from compiler output for {selection_name}")
    shutil.copy(HERE / "verify.ts", sdk)
    run([work / "node_modules/.bin/tsc", "--strict", "--exactOptionalPropertyTypes", "--noEmitOnError",
         "--target", "ES2022", "--module", "Node16", "--moduleResolution", "Node16",
         "--outDir", "js", "verify.ts"], cwd=sdk)
    return json.loads(run(["node", sdk / "js/verify.js"], cwd=sdk))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ontologyc", default=os.environ.get("ONTOLOGYC") or configured_compiler("gitview.actorOntologyc"))
    parser.add_argument("--stable-ontologyc", default=os.environ.get("STABLE_ONTOLOGYC") or configured_compiler("gitview.ontologyc"))
    parser.add_argument("--offline", action="store_true", help="Use npm's existing download cache")
    args = parser.parse_args()
    if not args.ontologyc:
        parser.error("Pass --ontologyc pointing to the compiler pinned in verification.json")
    with tempfile.TemporaryDirectory(prefix="gitview-operator-") as temp:
        work = Path(temp).resolve()
        for name in ("package.json", "package-lock.json"):
            shutil.copy(HERE / name, work)
        run(["npm", "ci", "--ignore-scripts", "--no-audit", "--no-fund"] + (["--offline"] if args.offline else []), cwd=work)
        controls = reproduce_subject(work, args.ontologyc, args.stable_ontologyc)
        outcomes = {name: exercise(name, work, args.ontologyc) for name in ("foundation-context.yaml", "composition-context.yaml")}
        print(json.dumps({"controls": controls, "execution": outcomes}, indent=2))


if __name__ == "__main__":
    main()
