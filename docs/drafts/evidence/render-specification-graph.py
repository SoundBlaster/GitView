#!/usr/bin/env python3
"""Render declared GitView candidate relations; this is not a readiness check."""
import argparse
import hashlib
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[3]
DRAFTS = ROOT / "docs" / "drafts"
OUTPUT = DRAFTS / "specification-graph-full.md"
ROOT_ID = "GITVIEW-SPEC-0001"


def render():
    paths = sorted(DRAFTS.glob("GITVIEW-SPEC-*.yaml"))
    specs = {}
    digest = hashlib.sha256()
    for path in paths:
        data = yaml.safe_load(path.read_bytes())
        key = data["id"]
        if key != path.stem or key in specs:
            raise ValueError(f"duplicate or mismatched candidate: {path}")
        specs[key] = data
        digest.update(path.name.encode() + b"\0" + path.read_bytes() + b"\0")
    children = {key: [] for key in specs}
    for key, data in specs.items():
        for edge in ("refines", "depends_on"):
            for target in data.get(edge, []):
                if target not in specs:
                    raise ValueError(f"missing {edge} target: {key} -> {target}")
        for parent in data.get("refines", []):
            children[parent].append(key)
    roots = [key for key, data in specs.items() if not data.get("refines")]
    if roots != [ROOT_ID]:
        raise ValueError(f"unexpected roots: {roots}")
    lines = [
        "# GitView — полный граф кандидатов", "",
        "Этот снимок создан из YAML в `docs/drafts/`. Отступы показывают `refines`; "
        "таблица ниже — прямые `depends_on`. Узел с несколькими родителями показан "
        "под каждым из них; повторная ссылка не является копией спецификации.", "",
        "Все статусы показаны как записаны в файлах. Структура не доказывает "
        "смысловую полноту, принятие, готовность к реализации или выполненные тесты.", "",
        f"Кандидатов: **{len(specs)}**. SHA-256 имён и содержимого исходных YAML: `{digest.hexdigest()}`.", "",
        "Воспроизведение и проверка снимка: `python docs/drafts/evidence/render-specification-graph.py` "
        "и та же команда с `--check` в Python environment SpecGraph.", "",
        "## Дерево уточнения", "",
    ]
    visited = set()
    active = set()

    def walk(key, depth):
        if key in active:
            raise ValueError(f"refines cycle at {key}")
        data = specs[key]
        title = data.get("title", key).removeprefix("GitView - ")
        title = title.replace("[", "\\[").replace("]", "\\]")
        status = f"{data.get('status', 'unknown')} / {data.get('draft_status', 'unknown')}"
        suffix = " — тот же узел под другим родителем" if key in visited else f" — {status}"
        lines.append(f"{'  ' * depth}- [{key}]({key}.yaml): {title}{suffix}")
        if key in visited:
            return
        visited.add(key)
        active.add(key)
        for child in sorted(children[key]):
            walk(child, depth + 1)
        active.remove(key)

    walk(ROOT_ID, 0)
    if visited != specs.keys():
        raise ValueError(f"unreachable: {sorted(specs.keys() - visited)}")
    lines += ["", "## Прямые зависимости", "", "| Кандидат | `depends_on` |", "| --- | --- |"]
    for key in sorted(specs):
        dependencies = specs[key].get("depends_on", [])
        links = ", ".join(f"[{dep[-4:]}]({dep}.yaml)" for dep in dependencies) or "—"
        lines.append(f"| [{key[-4:]}]({key}.yaml) | {links} |")
    lines.append("")
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = render()
    if args.check:
        if not OUTPUT.exists() or OUTPUT.read_text() != result:
            raise SystemExit("graph snapshot is missing or stale")
        print("graph snapshot matches candidate YAML")
    else:
        OUTPUT.write_text(result)
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
