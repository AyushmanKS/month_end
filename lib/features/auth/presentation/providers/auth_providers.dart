import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

enum GoogleAuthOutcome { upgraded, signedIntoExisting, failed }

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
  return ref.watch(appUserStreamProvider).valueOrNull;
});

class AuthController extends StateNotifier<AsyncValue<AppUser?>> {
  AuthController(this._repository) : super(const AsyncValue.data(null));

  final AuthRepository _repository;

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
      _run(() => _repository.upgradeWithEmail(email: email, password: password));

  Future<bool> signUpWithEmail(String email, String password) =>
      _run(() => _repository.signUpWithEmail(email: email, password: password));

  Future<bool> signInWithEmail(String email, String password) =>
      _run(() => _repository.signInWithEmail(email: email, password: password));

  Future<GoogleAuthOutcome> upgradeWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final (user, signedIntoExisting) = await _repository.upgradeWithGoogle();
      state = AsyncValue.data(user);
      return signedIntoExisting
          ? GoogleAuthOutcome.signedIntoExisting
          : GoogleAuthOutcome.upgraded;
    } catch (e, s) {
      state = AsyncValue.error(ErrorHandler.map(e, s), s);
      return GoogleAuthOutcome.failed;
    }
  }

  Future<bool> upgradeWithApple() => _run(_repository.upgradeWithApple);

  Future<bool> updateProfile({String? name, String? username}) =>
      _run(() => _repository.updateProfile(name: name, username: username));

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncValue.data(null);
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
  return AuthController(ref.watch(authRepositoryProvider));
});
