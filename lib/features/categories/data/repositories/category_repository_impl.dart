import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/expense_category.dart';

abstract class CategoryRepository {
  Future<List<ExpenseCategory>> fetchCategories();
}

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<List<ExpenseCategory>> fetchCategories() async {
    try {
      final rows = await _client.from('categories').select().order('name');
      if (rows.isEmpty) return presetCategories;
      return rows.map(ExpenseCategory.fromJson).toList();
    } catch (e) {
      AppLogger.instance
          .w('Falling back to preset categories (remote unavailable)', e);
      return presetCategories;
    }
  }
}
