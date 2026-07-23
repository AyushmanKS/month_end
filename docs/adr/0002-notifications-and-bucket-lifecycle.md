# ADR 0002 — Notifications, Activity & Bucket Lifecycle

Status: Accepted (design) — implementation pending, phased.
Supersedes the bucket-scoped `notifications` table introduced in 0001–0004.

## Problem

The current system stores one bucket-scoped table
`notifications(bucket_id, type, actor_uid, message, read_by uuid[])` and deletes
buckets with a hard `DELETE ... CASCADE`. Consequences observed in production:

- When an owner deletes a bucket, a member's realtime stream row simply
  disappears with no explanation ("bucket vanished" bug).
- A "bucket deleted" notification would be cascade-deleted together with the
  bucket, so it can never reach the affected members.
- `read_by uuid[]` cannot express per-recipient delivery, cannot target a
  non-member (removed/deleted users), and cannot produce an index-only unread
  count.
- Audit history and the per-user inbox are conflated in one table.

We need a production-grade notification + activity system (Slack / GitHub /
Notion / Splitwise class) that is event-sourced, idempotent, offline-first,
realtime, backwards-compatible during rollout, and scalable to tens of
thousands of notifications without redesign.

## Decision

### D1. Two planes: Activity (audit) and Notifications (inbox)

- **`bucket_activity`** — append-only, immutable, bucket-scoped event log. The
  objective audit history of a bucket. Read by all members. Never updated,
  never deleted by users (only physically purged when its bucket is purged).
- **`user_notifications`** — per-recipient inbox rows with their own read/archive
  state. Decoupled from bucket lifecycle: carries a denormalized `bucket_name`
  snapshot and uses `bucket_id ON DELETE SET NULL`, so a "bucket deleted"
  notification survives the bucket and still reads
  "Trip to Goa was deleted by Ayush."

Activity is the source of truth for *what happened*; notifications are a
disposable, per-user *delivery* derived from it.

### D2. Bucket lifecycle state machine (R1)

`status` is an explicit enum with transitions allowed only through
SECURITY DEFINER RPCs:

```
ACTIVE ──archive──▶ ARCHIVED ──unarchive──▶ ACTIVE
ACTIVE / ARCHIVED ──request_delete──▶ PENDING_DELETE
PENDING_DELETE ──restore (owner)──▶ ACTIVE
PENDING_DELETE ──(cron, window elapsed)──▶ DELETED
DELETED ──(cron, retention elapsed)──▶ PURGED (row physically removed)
```

- **ACTIVE** — normal.
- **ARCHIVED** — hidden from the active list, fully reversible, data intact.
- **PENDING_DELETE** — scheduled for deletion; hidden from members; restorable
  by the owner within a **30-day** restore window; members are notified.
- **DELETED** — tombstone; window elapsed; logically inaccessible; retained for
  audit for **90 days**, then purged.
- **PURGED** — physically hard-deleted by a purge job (or on GDPR request);
  `bucket_activity` cascades away with it, `user_notifications` survive via
  `SET NULL` + snapshot.

Finalized retention constants: restore window **30 days** (PENDING_DELETE →
DELETED); DELETED retention **90 days** (DELETED → PURGED); archived-notification
TTL **90 days**.

Columns on `buckets`: `status`, `deleted_at`, `deleted_by`, plus
`delete_after` (when PENDING_DELETE may advance to DELETED).

### D3. Deletion is communicated by notification, not by a visible tombstone

Row-level security hides every non-`ACTIVE`/`ARCHIVED` bucket from the normal
`buckets` SELECT for **all** clients. Deletion is delivered through the
**user_notifications fan-out** (with the `bucket_name` snapshot), not by keeping
the deleted row visible. This is the key backwards-compatibility and
correctness insight (see Alternatives A1): old clients simply stop seeing the
bucket (same as a hard delete from their view), while new clients receive the
explanatory inbox notification and purge their local copy. No RLS policy has to
simultaneously hide-for-old and show-for-new.

### D4. Single notification pipeline (R3) via an append-only event choke point

RPCs never write notifications directly. They emit **activity** through one
writer, `emit_activity(bucket, type, actor, summary, metadata)`, which inserts
into `bucket_activity`. An **AFTER INSERT trigger** on `bucket_activity` runs
`fan_out_notifications(activity_row)`, the single function that maps an event to
its recipients and inserts `user_notifications`. Any future producer (including
push) consumes this same pipeline. The trigger makes the guarantee structural:
every activity row fans out; no RPC can forget.

Non-bucket, system-level notifications (app_update, system_announcement) have no
activity row; they are inserted by a dedicated `emit_system_notification` admin
RPC that still routes through the same idempotent `_notify_user` writer. So the
*writer* (`_notify_user`) is the single choke point; the *sources* are (a) the
activity trigger and (b) the system emitter.

### D5. Event sourcing — activity is immutable (R2)

`bucket_activity` accepts INSERT only. No UPDATE, no DELETE — enforced three
ways: no RLS update/delete policy, revoked table grants, and a trigger that
raises on UPDATE/DELETE. Corrections are new events (Expense Added → Expense
Edited → Expense Deleted), never mutations of prior rows.

### D6. Idempotent fan-out (R4)

Every notification references its originating event via `event_id` (the
`bucket_activity.id`, or a generated id for system events). A unique constraint
`(recipient_uid, event_id)` plus `ON CONFLICT DO NOTHING` guarantees retries,
trigger re-fires, and manual replays can never duplicate a notification.
`event_id` is a plain uuid, **not** a foreign key, so purging activity never
cascades into a user's inbox.

### D7. Inbox states + TTL cleanup (R5)

Per-user state is Unread / Read / Archived, expressed as `read_at` (null =
unread) and `archived_at`. Users never hard-delete; they archive. A `pg_cron`
job removes archived rows after a TTL of **90 days**. Unread rows are kept
until read or archived.

### D8. Notification categories (R6)

`category` enum on `user_notifications`:
`system, bucket, expense, membership, ownership, security, billing,
announcement`. Enables trivial future filtering tabs and per-category
preferences. Each notification type maps to exactly one category.

### D9. Restore is event-driven and owner-only (R7)

`restore_bucket` is owner-only, moves PENDING_DELETE → ACTIVE, and emits
`bucket_restored` activity → fan-out → realtime, exactly like delete. The whole
lifecycle stays event-driven.

### D10. Server timestamps only (R8)

Every `bucket_activity.created_at` and `user_notifications.created_at` defaults
to Postgres `now()`. RPCs never accept client timestamps for these. Clients only
display. Note: the *expense* `occurred_at` remains client-provided (needed for
the offline local-date fix in 0007); the *activity event* timestamp is the
server record time. These are intentionally different facts.

### D11. Cursor/keyset pagination only (R9)

No OFFSET anywhere. Both tables paginate by `(created_at, id)` descending
keyset, so concurrent inserts never cause skipped or duplicated rows.
Supporting indexes: `user_notifications(recipient_uid, created_at desc, id desc)`
and `bucket_activity(bucket_id, created_at desc, id desc)`.

### D12. Notification preferences, future-ready (R10)

`user_notification_preferences(user_uid pk, prefs jsonb, updated_at)` where
`prefs` holds `category → channel → bool` (channels: in_app, push, email).
Defaults allow everything. No UI now. Fan-out consults prefs before inserting an
inbox row, **except** critical categories (`security`, `ownership`, and bucket
lifecycle) which always deliver. jsonb keeps the schema stable as categories
grow.

### D13. Offline deleted-bucket handling (R11, refined)

When the SyncEngine replays a queued command against a PENDING_DELETE / DELETED
bucket, the RPC returns a typed `bucket_gone` result. The engine then:

1. treats it as **terminal success** (removes the outbox command, no infinite
   retry),
2. writes a **local informational user_notification** ("Your change to 'X'
   wasn't applied — the bucket was deleted"),
3. records a **client-local audit entry** (Drift) explaining the skip.

Refinement over the original proposal: the skip is recorded **client-side**, not
as server `bucket_activity`. The offline actor no longer has read access to a
deleted bucket, so a server audit row there would be invisible and pointless;
the local audit + inbox notification give the user a complete trail where they
can actually see it.

### D15. Correlation id for end-to-end tracing

Every user action generates one `correlation_id` (uuid). It is stamped on the
`bucket_activity` row, copied by fan-out onto every `user_notifications` row it
produces, carried through realtime payloads and (future) push, and logged by the
client into sync logs and Sentry breadcrumbs/tags. This lets every artifact from
a single operation — activity, all fanned-out notifications, realtime delivery,
push, sync-engine log lines, and Sentry events — be traced together by one id.
The client generates the id at the point of action and passes it into the RPC
where possible; RPCs that are not yet correlation-aware fall back to a
server-generated id per event (a Phase 2 refinement threads a single id through
multi-event money RPCs).

### D14. Reads via definer RPC where RLS-per-row would be costly (R14)

`user_notifications` reads use direct RLS (`recipient_uid = auth.uid()` —
index-backed, trivial). `bucket_activity` reads go through a SECURITY DEFINER
`get_bucket_activity(bucket_id, cursor)` that checks membership **once** then
returns a keyset page, avoiding per-row RLS evaluation during pagination.

## Alternatives considered

- **A1 — Communicate deletion by keeping the tombstone row visible with
  `status=DELETED`.** Rejected: forces RLS to hide-for-old-clients and
  show-for-new simultaneously, and relies on realtime UPDATE semantics that are
  fragile across RLS. D3 (deliver via notification, hide the row for everyone)
  is simpler, backwards-compatible, and robust.
- **A2 — Keep `read_by uuid[]`.** Rejected: no index-only unread count, cannot
  target non-members, unbounded array growth.
- **A3 — Notifications written directly by each RPC.** Rejected: N places to keep
  correct; no single pipeline for push; easy to forget. D4's activity-trigger
  choke point is structural.
- **A4 — Fan-out via async queue (pgmq / server-side outbox) instead of a
  synchronous trigger.** Deferred: finance buckets have small member counts, so
  synchronous fan-out inside the writer transaction is cheap. The async queue is
  the documented escape hatch if a single bucket ever has thousands of members.
- **A5 — Single combined "events" table for bucket + system events.** Rejected
  for now: system events have no bucket and different retention; a small separate
  system-emitter path keeps `bucket_activity` clean while still funneling through
  the one idempotent writer.
- **A6 — Hard delete + "fire the notification first."** Rejected: no restore
  window, no audit retention, and a crash between notify and delete leaves
  inconsistent state. Soft-delete state machine (D2) is safer.

## Consequences

Positive:

- The "vanishing bucket" bug is fixed at the root: deletion is a durable,
  explained, per-user event.
- One idempotent pipeline for all notifications; push is a single future
  integration on `user_notifications` INSERT.
- Immutable audit trail suitable for a finance product.
- Index-only unread counts; keyset pagination that is correct under concurrent
  writes; scales to tens of thousands of rows.
- Backwards compatible: additive migration, legacy table retained during
  rollout.

Negative / costs:

- More tables, triggers, and RPCs to maintain.
- Fan-out duplicates the human-readable message per recipient (denormalized) —
  accepted for delivery independence and push readiness.
- Soft-delete + retention jobs add operational surface (cron).
- During rollout both the legacy `notifications` and the new tables are written,
  a temporary duplication.

## Performance & RLS (R14)

- **Unread count:** partial index
  `user_notifications(recipient_uid) WHERE read_at IS NULL AND archived_at IS
  NULL` → index-only scan, no sequential scan.
- **Inbox page:** composite `(recipient_uid, created_at desc, id desc)` keyset.
- **Activity page:** `(bucket_id, created_at desc, id desc)`, fetched via definer
  RPC (membership checked once).
- **RLS predicates** are equality on indexed columns (`recipient_uid =
  auth.uid()`), keeping realtime per-event RLS cheap.
- **FKs:** `bucket_activity.bucket_id ON DELETE CASCADE` (audit dies with a
  purged bucket); `user_notifications.bucket_id ON DELETE SET NULL` (inbox
  survives); `actor_uid ON DELETE SET NULL` everywhere ("deleted user");
  `event_id` is not a FK.
- Query plans to be verified with `EXPLAIN` at 10k+ rows before Phase 1 ships.

## Migration plan

- **0012 — lifecycle + two planes (additive, backwards compatible) (R13):**
  add `buckets.status/deleted_at/deleted_by/delete_after`;
  add `bucket_members.role default 'member'` (owner rows → 'owner');
  create `bucket_activity`, `user_notifications`,
  `user_notification_preferences`; RLS + realtime publication for the new
  tables; `emit_activity`, `fan_out_notifications` (trigger), `_notify_user`,
  `emit_system_notification`; rewrite `delete_bucket` to call
  `request_bucket_delete` (soft, PENDING_DELETE) so old clients keep working;
  add `archive_bucket`, `restore_bucket`, `remove_member`, `leave_bucket`;
  update `transfer_bucket_ownership` and the expense/budget/currency RPCs to
  `emit_activity`; RLS hides non-active buckets from SELECT; `pg_cron`
  (advance PENDING_DELETE→DELETED after window; DELETED→PURGED after retention;
  TTL archived notifications). Legacy `notifications` retained and still written.
- **0013 — enrich:** `pending_ownership_transfers` (accept/decline, mirrors
  `join_requests`); admin-role enforcement; time-partition `bucket_activity` /
  `user_notifications` by `created_at`.
- **0014 — cleanup:** drop the legacy `notifications` table once all clients are
  on the new pipeline.

Client (Drift schema v3): add `UserNotificationRows`, `BucketActivityRows`,
`SyncCursors`, and a client-local `SkippedActionAudit`; add
`status/deletedAt/deletedBy` to `Buckets` and `role` to `BucketMemberRows`;
hydrators for the per-user inbox (always on) and active-bucket activity; bucket
lifecycle handling that removes the local bucket and shows the inbox entry on a
deletion notification.

## Phased roadmap

- **Phase 0 (backend):** 0012 — fixes the vanishing-bucket bug immediately.
- **Phase 1 (client core):** Drift v3, inbox hydrator, per-user realtime,
  lifecycle handling, global Notifications screen.
- **Phase 2:** Bucket Activity timeline UI (audit tab).
- **Phase 3:** Deletion UX (multi-member guard, remove / transfer / leave,
  archive + Restore).
- **Phase 4:** Roles + enforcement.
- **Phase 5:** Retention jobs, keyset pagination in UI, badge polish,
  skipped-offline-action handling.
- **Phase 6 (future):** push (FCM/APNs Edge Function on `user_notifications`
  INSERT), ownership accept/decline, admin role, mentions, announcements,
  preferences UI.

## Future extensions

- Push notifications via one Edge Function on `user_notifications` INSERT.
- Ownership accept/decline (`pending_ownership_transfers`).
- Admin / viewer roles (the `role` column is already in place).
- Mentions and system announcements (categories already reserved).
- Per-category / per-channel preference UI (table already in place).
- Async fan-out queue if a single bucket ever reaches thousands of members.
