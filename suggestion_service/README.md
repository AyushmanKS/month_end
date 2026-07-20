# month_end suggestion service

Computes weekly spend-reduction suggestions with plain `pandas` — no ML, no paid API.
For each closed weekly bucket it compares this week's spend per category against the
average of prior closed weeks and writes rows into the `suggestions` table, which the
app renders live via Supabase Realtime.

## Two ways to run (pick one)

Both share `analyzer.py` / `pipeline.py` / `db.py`.

### A. GitHub Actions poller (card-free, PRD §1)
`run_poller.py` finds every closed week without suggestions and processes it.
Scheduled in [.github/workflows/suggestions.yml](../.github/workflows/suggestions.yml)
every 20 minutes. Set repo secret `SUPABASE_DB_URL` to your direct Postgres
connection string (Supabase → Project Settings → Database → Connection string).

### B. FastAPI webhook on Render (event-driven, PRD §4.7)
`app.py` exposes `POST /webhooks/week-closed`. Deploy on Render's free web service:

    uvicorn app:app --host 0.0.0.0 --port $PORT

Env vars: `DATABASE_URL` (required), `WEBHOOK_SECRET` (optional, verified against
the `x-webhook-secret` header). Then add a Supabase Database Webhook on
`weekly_buckets` UPDATE pointing at the Render URL.

## Local dev

    pip install -r requirements.txt
    pytest                       # runs test_analyzer.py
    export DATABASE_URL=postgres://...
    python run_poller.py
