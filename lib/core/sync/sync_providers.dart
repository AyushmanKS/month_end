import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared_providers/supabase_providers.dart';
import '../db/database_provider.dart';
import '../network/connectivity_providers.dart';
import 'outbox_repository.dart';
import 'sync_engine.dart';
import 'sync_status.dart';

final outboxRepositoryProvider = Provider<OutboxRepository>((ref) {
  return OutboxRepository(ref.watch(appDatabaseProvider));
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final engine = SyncEngine(
    ref.watch(supabaseClientProvider),
    ref.watch(outboxRepositoryProvider),
    ref.watch(syncStatusProvider.notifier),
  );

  ref.listen<AsyncValue<bool>>(isOnlineProvider, (previous, next) {
    if (next.value == true) unawaited(engine.sync());
  });

  ref.listen(authStateChangesProvider, (previous, next) {
    unawaited(engine.sync());
  });

  return engine;
});
