import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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
  final categories = ref.watch(categoriesProvider).value ?? presetCategories;
  for (final category in categories) {
    if (category.id == id) return category;
  }
  return null;
});

class CategoryController extends StateNotifier<AsyncValue<void>> {
  CategoryController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<ExpenseCategory?> addCustomCategory({
    required String name,
    required String iconKey,
  }) async {
    state = const AsyncValue.loading();
    try {
      final category = await _ref
          .read(categoryRepositoryProvider)
          .addCustomCategory(name: name, iconKey: iconKey);
      _ref.invalidate(categoriesProvider);
      state = const AsyncValue.data(null);
      return category;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      return null;
    }
  }

  Future<void> deleteCustomCategory(String id) async {
    await _ref.read(categoryRepositoryProvider).deleteCustomCategory(id);
    _ref.invalidate(categoriesProvider);
  }
}

final categoryControllerProvider =
    StateNotifierProvider<CategoryController, AsyncValue<void>>((ref) {
      return CategoryController(ref);
    });
