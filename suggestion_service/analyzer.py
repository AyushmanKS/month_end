"""Spend-suggestion logic. Pure pandas/numpy, no ML, no paid API.

Given a bucket and a just-closed week, compare this week's spend per category
against the historical average of prior closed weeks and flag categories whose
change exceeds a threshold.
"""

from __future__ import annotations

from dataclasses import dataclass

import pandas as pd

THRESHOLD_PERCENT = 25.0


@dataclass
class Suggestion:
    bucket_id: str
    week_id: str
    category_id: str | None
    message: str
    percent_change: float


def build_suggestions(
    expenses: pd.DataFrame,
    bucket_id: str,
    closed_week_id: str,
    closed_week_ids_in_order: list[str],
    category_names: dict[str, str],
    threshold: float = THRESHOLD_PERCENT,
) -> list[Suggestion]:
    """expenses: rows with columns [week_id, category_id, amount]."""
    if expenses.empty or closed_week_id not in closed_week_ids_in_order:
        return []

    prior_week_ids = [
        wid for wid in closed_week_ids_in_order if wid != closed_week_id
    ]
    if not prior_week_ids:
        return []

    df = expenses.copy()
    df["amount"] = pd.to_numeric(df["amount"], errors="coerce").fillna(0.0)
    df["category_id"] = df["category_id"].fillna("__uncategorised__")

    this_week = (
        df[df["week_id"] == closed_week_id]
        .groupby("category_id")["amount"]
        .sum()
    )

    prior = df[df["week_id"].isin(prior_week_ids)]
    per_week_category = (
        prior.groupby(["week_id", "category_id"])["amount"].sum().reset_index()
    )
    historical_avg = (
        per_week_category.groupby("category_id")["amount"].mean()
    )

    suggestions: list[Suggestion] = []
    for category_id, current in this_week.items():
        baseline = float(historical_avg.get(category_id, 0.0))
        if baseline <= 0:
            continue
        percent_change = (float(current) - baseline) / baseline * 100.0
        if percent_change < threshold:
            continue

        resolved_id = None if category_id == "__uncategorised__" else category_id
        label = category_names.get(category_id, "Overall")
        suggestions.append(
            Suggestion(
                bucket_id=bucket_id,
                week_id=closed_week_id,
                category_id=resolved_id,
                message=(
                    f"{label} spend is {percent_change:.0f}% above your "
                    f"{len(prior_week_ids)}-week average"
                ),
                percent_change=round(percent_change, 2),
            )
        )

    return suggestions
