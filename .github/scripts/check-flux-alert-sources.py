#!/usr/bin/env python3
import glob
import sys

import yaml

ALERT_FILE = "services/flux-notification/resources/app/alerts.yaml"
ALERT_NAME = "telegram"
DIRS = ("apps", "infrastructure", "services", "clusters")
EXTRA_NAMESPACES = {"flux-system", "kube-system"}
KINDS = (
    "GitRepository",
    "OCIRepository",
    "HelmRepository",
    "HelmChart",
    "Kustomization",
    "HelmRelease",
)


def docs(path):
    try:
        with open(path) as f:
            yield from yaml.safe_load_all(f)
    except yaml.YAMLError:
        return


def main():
    namespaces = set(EXTRA_NAMESPACES)
    for d in DIRS:
        for path in glob.glob(f"{d}/**/*.yaml", recursive=True):
            for doc in docs(path):
                if isinstance(doc, dict) and doc.get("kind") == "Namespace":
                    namespaces.add(doc["metadata"]["name"])

    alert = next(
        (
            d
            for d in docs(ALERT_FILE)
            if isinstance(d, dict)
            and d.get("kind") == "Alert"
            and d["metadata"]["name"] == ALERT_NAME
        ),
        None,
    )
    if alert is None:
        print(f"{ALERT_FILE}: Alert {ALERT_NAME} not found")
        return 1

    have = set()
    for src in alert["spec"].get("eventSources", []):
        if src.get("name") == "*":
            have.add((src["kind"], src.get("namespace", alert["metadata"]["namespace"])))

    want = {(k, ns) for ns in namespaces for k in KINDS}
    missing = sorted(want - have, key=lambda x: (x[1], x[0]))
    extra = sorted(have - want, key=lambda x: (x[1], x[0]))
    for kind, ns in missing:
        print(f"{ALERT_FILE}: Alert {ALERT_NAME} is missing - {{kind: {kind}, name: '*', namespace: {ns}}}")
    for kind, ns in extra:
        print(f"{ALERT_FILE}: Alert {ALERT_NAME} lists {kind} in {ns}, which has no Namespace in the repo")
    return 1 if missing or extra else 0


if __name__ == "__main__":
    sys.exit(main())
