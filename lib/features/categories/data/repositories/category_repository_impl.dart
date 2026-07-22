import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/expense_category.dart';

abstract class CategoryRepository {
  Future<List<ExpenseCategory>> fetchCategories();

  Future<ExpenseCategory> addCustomCategory({
    required String name,
    required String iconKey,
  });

  Future<void> deleteCustomCategory(String id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<List<ExpenseCategory>> fetchCategories() async {
    try {
      final rows = await _client
          .from('categories')
          .select()
          .order('is_preset', ascending: false)
          .order('name');
      if (rows.isEmpty) return presetCategories;
      return rows.map(ExpenseCategory.fromJson).toList();
    } catch (e) {
      AppLogger.instance.w(
        'Falling back to preset categories (remote unavailable)',
        e,
      );
      return presetCategories;
    }
  }

  @override
  Future<ExpenseCategory> addCustomCategory({
    required String name,
    required String iconKey,
  }) async {
    final row = await _client.rpc(
      'add_custom_category',
      params: {'p_name': name, 'p_icon': iconKey},
    );
    return ExpenseCategory.fromJson(Map<String, dynamic>.from(row as Map));
  }

  @override
  Future<void> deleteCustomCategory(String id) async {
    await _client.rpc('delete_custom_category', params: {'p_id': id});
  }
}
