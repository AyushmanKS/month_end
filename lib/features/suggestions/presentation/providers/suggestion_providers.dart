import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../../bucket/presentation/providers/bucket_providers.dart';
import '../../data/datasources/suggestion_remote_datasource.dart';
import '../../domain/entities/spend_suggestion.dart';

final suggestionRemoteDataSourceProvider = Provider<SuggestionRemoteDataSource>(
  (ref) {
    return SuggestionRemoteDataSource(ref.watch(supabaseClientProvider));
  },
);

final suggestionsProvider = StreamProvider<List<SpendSuggestion>>((ref) {
  final bucketId = ref.watch(activeBucketIdProvider);
  if (bucketId == null) return Stream.value(const []);
  return ref.watch(suggestionRemoteDataSourceProvider).watchForBucket(bucketId);
});
