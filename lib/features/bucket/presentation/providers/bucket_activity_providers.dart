import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/db/database_provider.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../data/datasources/bucket_activity_local_datasource.dart';
import '../../data/datasources/bucket_activity_remote_datasource.dart';
import '../../domain/entities/bucket_activity.dart';

final bucketActivityRemoteDataSourceProvider =
    Provider<BucketActivityRemoteDataSource>((ref) {
      return BucketActivityRemoteDataSource(ref.watch(supabaseClientProvider));
    });

final bucketActivityLocalDataSourceProvider =
    Provider<BucketActivityLocalDataSource>((ref) {
      return BucketActivityLocalDataSource(ref.watch(appDatabaseProvider));
    });

final _bucketActivityHydratorProvider = Provider.family<void, String>((
  ref,
  bucketId,
) {
  final local = ref.read(bucketActivityLocalDataSourceProvider);
  final sub = ref
      .read(bucketActivityRemoteDataSourceProvider)
      .watchActivity(bucketId)
      .listen((server) => unawaited(local.upsertMany(server)), onError: (_) {});
  ref.onDispose(sub.cancel);
});

final bucketActivityProvider =
    StreamProvider.family<List<BucketActivity>, String>((ref, bucketId) {
      ref.watch(_bucketActivityHydratorProvider(bucketId));
      return ref
          .watch(bucketActivityLocalDataSourceProvider)
          .watchActivity(bucketId);
    });

Future<int> loadOlderActivity(
  WidgetRef ref,
  String bucketId,
  BucketActivity? oldest,
) async {
  try {
    final older = await ref
        .read(bucketActivityRemoteDataSourceProvider)
        .loadOlder(
          bucketId: bucketId,
          beforeCreatedAt: oldest?.createdAt,
          beforeId: oldest?.id,
        );
    if (older.isNotEmpty) {
      await ref.read(bucketActivityLocalDataSourceProvider).upsertMany(older);
    }
    return older.length;
  } catch (_) {
    return 0;
  }
}
