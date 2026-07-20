"""Standalone poller (GitHub Actions free-minutes path, PRD §1).

Finds every closed week with no suggestions yet and processes it. Idempotent:
safe to run on a schedule because a week is skipped once its suggestions exist.
"""

from __future__ import annotations

import db
from pipeline import process_closed_week


def main() -> None:
    pending = db.fetch_pending_closed_weeks()
    total = 0
    for bucket_id, week_id in pending:
        total += process_closed_week(bucket_id, week_id)
    print(f"Processed {len(pending)} closed week(s); wrote {total} suggestion(s).")


if __name__ == "__main__":
    main()
