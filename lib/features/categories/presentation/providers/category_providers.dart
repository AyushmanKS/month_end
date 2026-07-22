import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/db/database_provider.dart';
import '../../../../core/network/connectivity_providers.dart';
import '../../../../core/sync/outbox_command.dart';
import '../../../../core/sync/outbox_repository.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../data/datasources/category_local_datasource.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/expense_category.dart';

const _uuid = Uuid();

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(ref.watch(supabaseClientProvider));
});

final categoryLocalDataSourceProvider = Provider<CategoryLocalDataSource>((
  ref,
) {
  return CategoryLocalDataSource(ref.watch(appDatabaseProvider));
});

final categoryHydratorProvider = Provider<void>((ref) {
  final local = ref.read(categoryLocalDataSourceProvider);
  final remote = ref.read(categoryRepositoryProvider);
  final outbox = ref.read(outboxRepositoryProvider);
  Future<void> hydrate() async {
    try {
      final server = await remote.fetchCategories();
      final pending = await outbox.pendingEntityIds('category');
      await local.reconcile(server, pending);
    } catch (_) {}
  }

  unawaited(hydrate());
  ref.listen<AsyncValue<bool>>(isOnlineProvider, (previous, next) {
    if (next.value == true) unawaited(hydrate());
  });
});

final categoriesProvider = StreamProvider<List<ExpenseCategory>>((ref) {
  ref.watch(categoryHydratorProvider);
  return ref.watch(categoryLocalDataSourceProvider).watchCategories().map((
    list,
  ) {
    return list.isEmpty ? presetCategories : list;
  });
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

  CategoryLocalDataSource get _local =>
      _ref.read(categoryLocalDataSourceProvider);
  OutboxRepository get _outbox => _ref.read(outboxRepositoryProvider);

  Future<ExpenseCategory?> addCustomCategory({
    required String name,
    required String iconKey,
  }) async {
    state = const AsyncValue.loading();
    try {
      final id = _uuid.v4();
      final category = ExpenseCategory(
        id: id,
        name: name,
        iconKey: iconKey,
        isPreset: false,
      );
      await _local.upsertLocal(category, syncState: 'pending');
      await _outbox.enqueue(
        OutboxCommand(
          id: id,
          op: OutboxOp.categoryCreate,
          entity: 'category',
          entityId: id,
          priority: 20,
          payload: {'name': name, 'icon': iconKey},
        ),
      );
      unawaited(_ref.read(syncEngineProvider).sync());
      state = const AsyncValue.data(null);
      return category;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      return null;
    }
  }

  Future<void> deleteCustomCategory(String id) async {
    await _local.deleteLocal(id);
    await _outbox.enqueue(
      OutboxCommand(
        id: _uuid.v4(),
        op: OutboxOp.categoryDelete,
        entity: 'category',
        entityId: id,
        payload: const {},
      ),
    );
    unawaited(_ref.read(syncEngineProvider).sync());
  }
}

final categoryControllerProvider =
    StateNotifierProvider<CategoryController, AsyncValue<void>>((ref) {
      return CategoryController(ref);
    });
