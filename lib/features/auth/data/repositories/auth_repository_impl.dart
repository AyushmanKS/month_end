import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._client);

  final AuthRemoteDataSource _remote;
  final SupabaseClient _client;

  @override
  AppUser? get currentUser {
    final user = _remote.currentAuthUser;
    if (user == null) return null;
    return AppUser(
      id: user.id,
      authType: user.isAnonymous ? AuthType.anonymous : AuthType.email,
      email: user.email,
    );
  }

  @override
  Stream<AppUser?> watchUser() {
    return _client.auth.onAuthStateChange.asyncMap((state) async {
      final user = state.session?.user;
      if (user == null) return null;
      final profile = await _remote.fetchProfile(user.id);
      return profile ??
          AppUser(
            id: user.id,
            authType:
                user.isAnonymous ? AuthType.anonymous : AuthType.email,
            email: user.email,
          );
    });
  }

  @override
  Future<AppUser> ensureSignedIn() async {
    final existing = _remote.currentAuthUser;
    if (existing != null) {
      final profile = await _remote.fetchProfile(existing.id);
      if (profile != null) return profile;
      return AppUser(
        id: existing.id,
        authType:
            existing.isAnonymous ? AuthType.anonymous : AuthType.email,
        email: existing.email,
      );
    }
    AppLogger.instance.i('No session found; signing in anonymously');
    return _remote.signInAnonymously();
  }

  @override
  Future<AppUser> signInAnonymously() => _remote.signInAnonymously();

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _remote.signInWithEmail(email, password);

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
  }) =>
      _remote.signUpWithEmail(email, password);

  @override
  Future<AppUser> upgradeWithEmail({
    required String email,
    required String password,
  }) =>
      _remote.upgradeWithEmail(email, password);

  @override
  Future<AppUser> signInWithGoogle() async {
    await _remote.signInWithOAuth(OAuthProvider.google);
    return ensureSignedIn();
  }

  @override
  Future<AppUser> signInWithApple() async {
    await _remote.signInWithOAuth(OAuthProvider.apple);
    return ensureSignedIn();
  }

  @override
  Future<AppUser> upgradeWithGoogle() async {
    await _remote.linkOAuthIdentity(OAuthProvider.google);
    return ensureSignedIn();
  }

  @override
  Future<AppUser> upgradeWithApple() async {
    await _remote.linkOAuthIdentity(OAuthProvider.apple);
    return ensureSignedIn();
  }

  @override
  Future<AppUser> updateProfile({String? name, String? username}) =>
      _remote.updateProfile(name: name, username: username);

  @override
  Future<void> signOut() => _remote.signOut();
}
