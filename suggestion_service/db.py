"""Postgres access shared by the webhook and the poller.

Connects with the direct Supabase Postgres connection string in DATABASE_URL.
"""

from __future__ import annotations

import os

import pandas as pd
import psycopg2
import psycopg2.extras

from analyzer import Suggestion


def _connect():
    dsn = os.environ["DATABASE_URL"]
    return psycopg2.connect(dsn)


def fetch_closed_weeks_in_order(bucket_id: str) -> list[str]:
    with _connect() as conn, conn.cursor() as cur:
        cur.execute(
            """
            select id from weekly_buckets
            where bucket_id = %s and status = 'closed'
            order by week_index
            """,
            (bucket_id,),
        )
        return [row[0] for row in cur.fetchall()]


def fetch_expenses(bucket_id: str) -> pd.DataFrame:
    with _connect() as conn:
        return pd.read_sql(
            """
            select week_id, category_id, amount
            from expenses
            where bucket_id = %(bucket_id)s and week_id is not null
            """,
            conn,
            params={"bucket_id": bucket_id},
        )


def fetch_category_names() -> dict[str, str]:
    with _connect() as conn, conn.cursor() as cur:
        cur.execute("select id, name from categories")
        return {str(row[0]): row[1] for row in cur.fetchall()}


def fetch_pending_closed_weeks() -> list[tuple[str, str]]:
    """Closed weeks that have no suggestions yet. Returns (bucket_id, week_id)."""
    with _connect() as conn, conn.cursor() as cur:
        cur.execute(
            """
            select w.bucket_id, w.id
            from weekly_buckets w
            where w.status = 'closed'
              and not exists (
                select 1 from suggestions s where s.week_id = w.id
              )
            """
        )
        return [(row[0], row[1]) for row in cur.fetchall()]


def write_suggestions(suggestions: list[Suggestion]) -> None:
    if not suggestions:
        return
    with _connect() as conn, conn.cursor() as cur:
        psycopg2.extras.execute_values(
            cur,
            """
            insert into suggestions
              (bucket_id, week_id, category_id, message, percent_change)
            values %s
            """,
            [
                (
                    s.bucket_id,
                    s.week_id,
                    s.category_id,
                    s.message,
                    s.percent_change,
                )
                for s in suggestions
            ],
        )
        conn.commit()
