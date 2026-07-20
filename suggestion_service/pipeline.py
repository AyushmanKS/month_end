"""Glue: for a given (bucket, closed week) produce and persist suggestions."""

from __future__ import annotations

import db
from analyzer import build_suggestions


def process_closed_week(bucket_id: str, week_id: str) -> int:
    closed_week_ids = db.fetch_closed_weeks_in_order(bucket_id)
    expenses = db.fetch_expenses(bucket_id)
    category_names = db.fetch_category_names()

    suggestions = build_suggestions(
        expenses=expenses,
        bucket_id=bucket_id,
        closed_week_id=week_id,
        closed_week_ids_in_order=closed_week_ids,
        category_names=category_names,
    )
    db.write_suggestions(suggestions)
    return len(suggestions)
