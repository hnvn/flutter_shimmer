#!/usr/bin/env python3
"""Summarize Flutter lcov output for the terminal or GitHub Actions."""

from __future__ import annotations

import argparse
import os
from pathlib import Path


def parse_lcov(path: Path) -> dict[str, tuple[int, int]]:
    files: dict[str, list[int]] = {}
    current: str | None = None
    for raw in path.read_text(encoding="utf-8").splitlines():
        if raw.startswith("SF:"):
            current = raw[3:]
            files[current] = [0, 0]
        elif raw.startswith("DA:") and current is not None:
            _line, hits = raw[3:].split(",")
            files[current][0] += 1
            if int(hits) > 0:
                files[current][1] += 1
    return {name: (total, hit) for name, (total, hit) in files.items()}


def percent(hit: int, total: int) -> float:
    if total == 0:
        return 0.0
    return 100.0 * hit / total


def format_rows(files: dict[str, tuple[int, int]]) -> list[tuple[str, str, str]]:
    rows: list[tuple[str, str, str]] = []
    total_lines = 0
    total_hits = 0
    for name, (line_count, hits) in sorted(files.items()):
        total_lines += line_count
        total_hits += hits
        short = name.replace("\\", "/")
        if "/lib/" in short:
            short = short[short.index("/lib/") + 1 :]
        rows.append(
            (short, f"{percent(hits, line_count):.1f}%", f"{hits}/{line_count}")
        )
    rows.append(
        ("Total", f"{percent(total_hits, total_lines):.1f}%", f"{total_hits}/{total_lines}")
    )
    return rows


def write_github_summary(rows: list[tuple[str, str, str]]) -> None:
    summary = os.environ.get("GITHUB_STEP_SUMMARY")
    if not summary:
        return
    lines = [
        "## Test coverage",
        "",
        "| File | Lines | Hits |",
        "| --- | ---: | ---: |",
    ]
    for name, line_pct, hits in rows:
        lines.append(f"| `{name}` | {line_pct} | {hits} |")
    lines.append("")
    lines.append(
        "Uploaded to [Codecov](https://codecov.io/gh/hnvn/flutter_shimmer) when `CODECOV_TOKEN` is set."
    )
    Path(summary).write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--lcov",
        default="coverage/lcov.info",
        help="Path to lcov.info from flutter test --coverage",
    )
    parser.add_argument(
        "--github-summary",
        action="store_true",
        help="Also write a markdown table to GITHUB_STEP_SUMMARY",
    )
    args = parser.parse_args()

    lcov = Path(args.lcov)
    if not lcov.is_file():
        raise SystemExit(f"Missing {lcov}. Run: flutter test --coverage")

    rows = format_rows(parse_lcov(lcov))
    width = max(len(name) for name, _pct, _hits in rows)
    for name, line_pct, hits in rows:
        print(f"{name:<{width}}  {line_pct:>6}  {hits}")

    if args.github_summary:
        write_github_summary(rows)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
