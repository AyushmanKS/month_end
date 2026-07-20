"""FastAPI webhook target (Render free tier deployment path, PRD §4.7).

Supabase Database Webhook posts here when a weekly_buckets row flips to 'closed'.
"""

from __future__ import annotations

import os

from fastapi import FastAPI, Header, HTTPException

from pipeline import process_closed_week

app = FastAPI(title="month_end suggestion service")

WEBHOOK_SECRET = os.environ.get("WEBHOOK_SECRET", "")


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


@app.post("/webhooks/week-closed")
async def week_closed(payload: dict, x_webhook_secret: str = Header(default="")):
    if WEBHOOK_SECRET and x_webhook_secret != WEBHOOK_SECRET:
        raise HTTPException(status_code=401, detail="Invalid webhook secret")

    record = payload.get("record") or {}
    old_record = payload.get("old_record") or {}

    if record.get("status") != "closed":
        return {"skipped": "not a close event"}
    if old_record.get("status") == "closed":
        return {"skipped": "already closed"}

    bucket_id = record.get("bucket_id")
    week_id = record.get("id")
    if not bucket_id or not week_id:
        raise HTTPException(status_code=400, detail="Missing bucket_id/week_id")

    created = process_closed_week(bucket_id, week_id)
    return {"created_suggestions": created}
