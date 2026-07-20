import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/spend_suggestion.dart';

class SuggestionRemoteDataSource {
  SuggestionRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _table = 'suggestions';

  Stream<List<SpendSuggestion>> watchForBucket(String bucketId) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('bucket_id', bucketId)
        .order('created_at', ascending: false)
        .map((rows) => rows.map(SpendSuggestion.fromJson).toList());
  }
}
