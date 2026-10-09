#!/usr/bin/env python3
import os
import re
import shutil
import subprocess
import sys
import tempfile

import yaml

RULE_LABELS = {"loki_rule": "loki", "prometheus_rule": "prometheus"}
GROUPS_RE = re.compile(r"^groups:", re.MULTILINE)


def check_groups(rules):
    if not isinstance(rules, dict) or not isinstance(rules.get("groups"), list):
        return ["no top-level groups list"]
    errs = []
    if not rules["groups"]:
        errs.append("groups list is empty")
    for i, group in enumerate(rules["groups"]):
        if not isinstance(group, dict) or not group.get("name"):
            errs.append(f"group {i} has no name")
            continue
        name = group["name"]
        items = group.get("rules")
        if not isinstance(items, list) or not items:
            errs.append(f"group {name} has no rules")
            continue
        for j, rule in enumerate(items):
            if not isinstance(rule, dict):
                errs.append(f"group {name} rule {j} is not a mapping")
                continue
            kinds = [k for k in ("alert", "record") if rule.get(k)]
            if len(kinds) != 1:
                errs.append(f"group {name} rule {j} needs exactly one of alert/record")
            if not isinstance(rule.get("expr"), str) or not rule["expr"].strip():
                errs.append(f"group {name} rule {j} has no expr")
    return errs


def lokitool_lint(lokitool, text):
    with tempfile.NamedTemporaryFile("w", suffix=".yaml", delete=False) as f:
        f.write(text)
    try:
        res = subprocess.run(
            [lokitool, "rules", "lint", "--dry-run", f.name],
            capture_output=True,
            text=True,
        )
    finally:
        os.unlink(f.name)
    if res.returncode != 0:
        return [(res.stderr or res.stdout).strip()]
    return []


def embedded(doc):
    if not isinstance(doc, dict) or doc.get("kind") != "ConfigMap":
        return
    labels = (doc.get("metadata") or {}).get("labels") or {}
    flavour = next((v for k, v in RULE_LABELS.items() if k in labels), None)
    for key, value in (doc.get("data") or {}).items():
        if not isinstance(value, str):
            continue
        if flavour or GROUPS_RE.search(value):
            yield key, value, flavour or "prometheus"


def main(paths):
    lokitool = os.environ.get("LOKITOOL") or shutil.which("lokitool")
    failed = False
    for path in paths:
        with open(path, encoding="utf-8") as f:
            try:
                docs = list(yaml.safe_load_all(f))
            except yaml.YAMLError:
                continue
        for doc in docs:
            for key, text, flavour in embedded(doc):
                where = f"{path}: {doc['metadata'].get('name')}/{key}"
                try:
                    errs = check_groups(yaml.safe_load(text))
                except yaml.YAMLError as e:
                    errs = [str(e)]
                if not errs and flavour == "loki" and lokitool:
                    errs = lokitool_lint(lokitool, text)
                for err in errs:
                    print(f"{where}: {err}")
                    failed = True
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
