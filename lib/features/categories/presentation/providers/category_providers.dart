import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/expense_category.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(ref.watch(supabaseClientProvider));
});

final categoriesProvider = FutureProvider<List<ExpenseCategory>>((ref) {
  return ref.watch(categoryRepositoryProvider).fetchCategories();
});

final categoryByIdProvider = Provider.family<ExpenseCategory?, String?>((
  ref,
  id,
) {
  if (id == null) return null;
  final categories =
      ref.watch(categoriesProvider).valueOrNull ?? presetCategories;
  for (final category in categories) {
    if (category.id == id) return category;
  }
  return null;
});
