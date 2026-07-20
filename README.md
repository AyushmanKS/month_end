# month_end

A shared household expense-bucket app (Flutter + Supabase). A monthly budget is split
into calendar-aware weekly buckets; members log expenses, big one-off spends rebalance
the remaining weeks, and everyone stays in sync via Supabase Realtime.

## Architecture

Clean Architecture, feature-first. Each feature has `data/`, `domain/`, `presentation/`
layers. The `domain` layer is pure Dart (no Flutter/Supabase imports); every repository
is an interface in `domain/repositories` implemented in `data/repositories`, so no widget
touches Supabase directly:

> Widget → Riverpod provider → repository interface → data source → Supabase

```
lib/
├── app/            # bootstrap, MaterialApp.router, go_router config
├── core/           # constants, theme, logging, error, utils, shared widgets, services
├── features/       # auth, bucket, expenses, categories, notifications, suggestions, profile
├── shared_providers/  # SupabaseClient + auth-state providers
└── shared_widgets/    # splash + floating-nav shell
supabase/migrations/   # schema, RLS policies, category seed
suggestion_service/    # Python (pandas) weekly suggestion engine
```

State: **Riverpod** (plain providers). Routing: **go_router** with a `ShellRoute`
driving the custom floating bottom nav.

> Note: the PRD called for `freezed`/`json_serializable`/`riverpod_generator`/`isar`
> code generation. This implementation uses hand-written immutable models and plain
> Riverpod instead, so the project compiles with no `build_runner` step. Offline caching
> (Isar/Hive) is not yet wired. Both are drop-in additions later.

## Setup

1. **Flutter deps**

   ```
   flutter pub get
   ```

2. **Supabase** — create a free project, then in the dashboard:
   - Authentication → enable **Anonymous**, **Google**, **Apple**, **Email/Password**.
   - SQL editor → run the three files in `supabase/migrations/` in order
     (`0001_schema.sql`, `0002_rls_policies.sql`, `0003_seed_categories.sql`).

3. **Env** — copy `.env.example` to `.env` and fill in:

   ```
   SUPABASE_URL / SUPABASE_ANON_KEY   # from Supabase → API settings
   CLOUDINARY_CLOUD_NAME / CLOUDINARY_UPLOAD_PRESET   # unsigned preset, optional
   SENTRY_DSN                          # optional, release crash reporting
   ```

   `.env` is git-ignored; `.env.example` is the tracked template.

4. **Run**

   ```
   flutter run
   ```

   With no credentials the app boots in "disconnected" mode (splash shows a retry) —
   fill `.env` to connect.

5. **Suggestion engine** (optional) — see [suggestion_service/README.md](suggestion_service/README.md).

## Tests

```
flutter test                              # weekly-allocation logic
cd suggestion_service && pytest           # pandas suggestion logic
```

## What's implemented vs. manual

Code, structure, feature logic, UI/animations, RLS policies, local threshold alerts,
and the Python service are all in the repo. Steps that need your accounts/keys
(Supabase project, Cloudinary preset, Sentry DSN, Render/GitHub deploy, Apple/Google
OAuth client setup) are listed in PRD §10 and the setup steps above.
