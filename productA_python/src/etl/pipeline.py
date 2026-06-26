"""Illustrative ETL stage: normalize raw event records.

Pure transform — I/O happens at the edges, this function just maps input to output.
"""
from __future__ import annotations

from typing import Iterable


def normalize_events(records: Iterable[dict]) -> list[dict]:
    """Lowercase event names and drop records missing an id.

    Idempotent and safe on empty input.
    """
    out: list[dict] = []
    for r in records:
        if not r.get("id"):
            continue
        out.append({**r, "event": str(r.get("event", "")).lower()})
    return out
