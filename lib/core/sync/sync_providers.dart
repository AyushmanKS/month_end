import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared_providers/supabase_providers.dart';
import '../db/database_provider.dart';
import '../network/backend_health_service.dart';
import '../network/connectivity_providers.dart';
import 'outbox_repository.dart';
import 'sync_dispatcher.dart';
import 'sync_engine.dart';
import 'sync_status.dart';

final outboxRepositoryProvider = Provider<OutboxRepository>((ref) {
  return OutboxRepository(ref.watch(appDatabaseProvider));
});

final backendHealthServiceProvider = Provider<BackendHealthService>((ref) {
  return BackendHealthService(
    dotenv.maybeGet('SUPABASE_URL') ?? '',
    dotenv.maybeGet('SUPABASE_ANON_KEY') ?? '',
  );
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final health = ref.watch(backendHealthServiceProvider);
  final engine = SyncEngine(
    ref.watch(outboxRepositoryProvider),
    ref.watch(syncStatusProvider.notifier),
    SupabaseSyncDispatcher(client),
    () => client.auth.currentUser != null,
    health.isReachable,
  );

  ref.listen<AsyncValue<bool>>(isOnlineProvider, (previous, next) {
    if (next.value == true) unawaited(engine.sync());
  });

  ref.listen(authStateChangesProvider, (previous, next) {
    unawaited(engine.sync());
  });

  return engine;
});
