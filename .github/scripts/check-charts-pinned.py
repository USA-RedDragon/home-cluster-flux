#!/usr/bin/env python3
import sys

import yaml


def check(doc):
    if not isinstance(doc, dict):
        return None
    api = str(doc.get("apiVersion", ""))
    kind = doc.get("kind")
    spec = doc.get("spec") or {}
    if api.startswith("helm.toolkit.fluxcd.io/") and kind == "HelmRelease":
        if ((spec.get("chart") or {}).get("spec") or {}).get("version"):
            return None
        if spec.get("chartRef"):
            return None
        return "HelmRelease missing version"
    if api.startswith("source.toolkit.fluxcd.io/") and kind == "OCIRepository":
        ref = spec.get("ref") or {}
        if ref.get("tag") or ref.get("digest"):
            return None
        return "OCIRepository missing ref.tag or ref.digest"
    return None


def main(paths):
    failed = False
    for path in paths:
        with open(path, encoding="utf-8") as f:
            try:
                docs = list(yaml.safe_load_all(f))
            except yaml.YAMLError as e:
                print(f"{path}: {e}")
                failed = True
                continue
        for doc in docs:
            err = check(doc)
            if err:
                print(f"{err}: {path}")
                failed = True
                break
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
