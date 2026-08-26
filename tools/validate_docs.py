#!/usr/bin/env python3
"""Validate relative Markdown links and required IdleNecro canon markers."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LINK_PATTERN = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
REQUIRED_MARKERS = (
    "grave_caller",
    "blood_weaver",
    "bone_warden",
    "plague_herald",
    "128×64",
    "15–25",
    "8 godzin",
)


def markdown_files() -> list[Path]:
    return sorted(
        path
        for path in (ROOT / "agents").rglob("*.md")
        if ".git" not in path.parts
    )


def validate_links(path: Path, text: str, errors: list[str]) -> None:
    for raw_target in LINK_PATTERN.findall(text):
        target = raw_target.strip().split("#", 1)[0]
        if not target or "://" in target or target.startswith("mailto:"):
            continue
        resolved = (path.parent / target).resolve()
        if not resolved.exists():
            errors.append(f"{path.relative_to(ROOT)}: missing link target {raw_target}")


def main() -> int:
    errors: list[str] = []
    documents = markdown_files()
    corpus = "\n".join(path.read_text(encoding="utf-8") for path in documents)

    for path in documents:
        validate_links(path, path.read_text(encoding="utf-8"), errors)

    for marker in REQUIRED_MARKERS:
        if marker not in corpus:
            errors.append(f"missing required canon marker: {marker}")

    if errors:
        print("Documentation validation failed:", file=sys.stderr)
        print("\n".join(f"- {error}" for error in errors), file=sys.stderr)
        return 1

    print(f"Documentation validation passed ({len(documents)} Markdown files).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
