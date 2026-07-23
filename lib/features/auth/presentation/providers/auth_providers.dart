import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/db/database_provider.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

enum GoogleAuthOutcome { upgraded, signedIntoExisting, canceled, failed }

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(supabaseClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(supabaseClientProvider),
  );
});

final appUserStreamProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).watchUser();
});

final currentAppUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(appUserStreamProvider).value;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(appUserStreamProvider).value?.isAuthenticated ?? false;
});

class AuthController extends StateNotifier<AsyncValue<AppUser?>> {
  AuthController(this._repository, this._db, this._prefs)
    : super(const AsyncValue.data(null));

  final AuthRepository _repository;
  final AppDatabase _db;
  final SharedPreferences _prefs;

  static const String _transferTokenKey = 'pending_bucket_transfer_token';

  Future<void> _stageTransferIfGuest() async {
    final user = _repository.currentUser;
    if (user == null || user.isAuthenticated) return;
    try {
      final token = await _repository.stageBucketTransfer();
      if (token != null) await _prefs.setString(_transferTokenKey, token);
    } catch (_) {}
  }

  Future<void> claimPendingTransfer() async {
    final token = _prefs.getString(_transferTokenKey);
    if (token == null) return;
    final user = _repository.currentUser;
    if (user == null || user.isAnonymous) return;
    try {
      await _repository.claimBucketTransfer(token);
    } catch (_) {}
    await _prefs.remove(_transferTokenKey);
  }

  Future<AppUser?> ensureSignedIn() async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.ensureSignedIn();
      state = AsyncValue.data(user);
      return user;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return null;
    }
  }

  Future<bool> upgradeWithEmail(String email, String password) =>
      _run(() async {
        await _stageTransferIfGuest();
        final user = await _repository.upgradeWithEmail(
          email: email,
          password: password,
        );
        await claimPendingTransfer();
        return user;
      });

  Future<bool> signUpWithEmail(String email, String password) =>
      _run(() => _repository.signUpWithEmail(email: email, password: password));

  Future<bool> signInWithEmail(String email, String password) =>
      _run(() => _repository.signInWithEmail(email: email, password: password));

  Future<GoogleAuthOutcome> upgradeWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await _stageTransferIfGuest();
      final (user, signedIntoExisting) = await _repository.upgradeWithGoogle();
      await claimPendingTransfer();
      state = AsyncValue.data(user);
      return signedIntoExisting
          ? GoogleAuthOutcome.signedIntoExisting
          : GoogleAuthOutcome.upgraded;
    } catch (e, s) {
      final mapped = ErrorHandler.map(e, s);
      if (mapped is CanceledException) {
        state = const AsyncValue.data(null);
        return GoogleAuthOutcome.canceled;
      }
      state = AsyncValue.error(mapped, s);
      return GoogleAuthOutcome.failed;
    }
  }

  Future<bool> upgradeWithApple() => _run(_repository.upgradeWithApple);

  Future<bool> updateProfile({String? name, String? username}) =>
      _run(() => _repository.updateProfile(name: name, username: username));

  Future<void> signOut() async {
    await _repository.signOut();
    await _db.clearAll();
    state = const AsyncValue.data(null);
  }

  Future<bool> deleteAccount() async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteAccount();
      await _db.clearAll();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }

  Future<bool> _run(Future<AppUser> Function() action) async {
    state = const AsyncValue.loading();
    try {
      final user = await action();
      state = AsyncValue.data(user);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return false;
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AppUser?>>((ref) {
      return AuthController(
        ref.watch(authRepositoryProvider),
        ref.watch(appDatabaseProvider),
        ref.watch(sharedPreferencesProvider),
      );
    });
