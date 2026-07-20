import pandas as pd

from analyzer import build_suggestions


def _expenses(rows):
    return pd.DataFrame(rows, columns=["week_id", "category_id", "amount"])


def test_flags_category_above_threshold():
    expenses = _expenses(
        [
            ("w1", "food", 100),
            ("w2", "food", 100),
            ("w3", "food", 200),
        ]
    )
    result = build_suggestions(
        expenses=expenses,
        bucket_id="b1",
        closed_week_id="w3",
        closed_week_ids_in_order=["w1", "w2", "w3"],
        category_names={"food": "Food"},
    )
    assert len(result) == 1
    assert result[0].category_id == "food"
    assert result[0].percent_change == 100.0


def test_no_history_yields_nothing():
    expenses = _expenses([("w1", "food", 100)])
    result = build_suggestions(
        expenses=expenses,
        bucket_id="b1",
        closed_week_id="w1",
        closed_week_ids_in_order=["w1"],
        category_names={"food": "Food"},
    )
    assert result == []


def test_below_threshold_is_ignored():
    expenses = _expenses(
        [
            ("w1", "food", 100),
            ("w2", "food", 110),
        ]
    )
    result = build_suggestions(
        expenses=expenses,
        bucket_id="b1",
        closed_week_id="w2",
        closed_week_ids_in_order=["w1", "w2"],
        category_names={"food": "Food"},
    )
    assert result == []
