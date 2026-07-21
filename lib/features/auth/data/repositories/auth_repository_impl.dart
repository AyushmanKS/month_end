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
    return _client.auth.onAuthStateChange
        .asyncMap<AppUser?>((state) async {
          final user = state.session?.user;
          if (user == null) return null;
          final resolvedType = _resolveType(user);
          final meta = user.userMetadata ?? const {};
          var metaName =
              (meta['full_name'] ?? meta['name']) as String? ??
              _identityValue(user, const ['full_name', 'name']);
          var metaPhoto =
              (meta['avatar_url'] ?? meta['picture']) as String? ??
              _identityValue(user, const ['avatar_url', 'picture']);
          AppUser? profile;
          try {
            profile = await _remote.fetchProfile(user.id);
          } catch (_) {
            profile = null;
          }
          final profileNameMissing =
              profile == null || profile.name == null || profile.name!.isEmpty;
          if (metaName == null &&
              profileNameMissing &&
              (resolvedType == AuthType.google ||
                  resolvedType == AuthType.apple)) {
            final (serverName, serverPhoto) = await _serverIdentity();
            metaName ??= serverName;
            metaPhoto ??= serverPhoto;
          }
          if (profile != null) {
            final needsName =
                (profile.name == null || profile.name!.isEmpty) &&
                metaName != null;
            final needsPhoto = profile.photoUrl == null && metaPhoto != null;
            if (profile.authType != resolvedType || needsName || needsPhoto) {
              final name = profile.name ?? metaName;
              final photo = profile.photoUrl ?? metaPhoto;
              try {
                await _remote.setAuthType(
                  user.id,
                  resolvedType,
                  user.email,
                  name: name,
                  photoUrl: photo,
                );
              } catch (_) {}
              profile = profile.copyWith(
                authType: resolvedType,
                email: user.email ?? profile.email,
                name: name,
                photoUrl: photo,
              );
            }
          }
          return profile ??
              AppUser(
                id: user.id,
                authType: resolvedType,
                email: user.email,
                name: metaName,
                photoUrl: metaPhoto,
              );
        })
        .handleError((Object error, StackTrace stack) {
          AppLogger.instance.w('Auth stream error ignored', error);
        });
  }

  Future<(String?, String?)> _serverIdentity() async {
    try {
      final identities = await _client.auth.getUserIdentities();
      String? pick(List<String> keys) {
        for (final identity in identities) {
          final data = identity.identityData;
          if (data == null) continue;
          for (final key in keys) {
            final value = data[key];
            if (value is String && value.isNotEmpty) return value;
          }
        }
        return null;
      }

      return (
        pick(const ['full_name', 'name']),
        pick(const ['avatar_url', 'picture']),
      );
    } catch (_) {
      return (null, null);
    }
  }

  String? _identityValue(User user, List<String> keys) {
    final identities = user.identities;
    if (identities == null) return null;
    for (final identity in identities) {
      final data = identity.identityData;
      if (data == null) continue;
      for (final key in keys) {
        final value = data[key];
        if (value is String && value.isNotEmpty) return value;
      }
    }
    return null;
  }

  AuthType _resolveType(User user) {
    final providers = user.appMetadata['providers'];
    if (providers is List) {
      if (providers.contains('google')) return AuthType.google;
      if (providers.contains('apple')) return AuthType.apple;
      if (providers.contains('email')) return AuthType.email;
    }
    return user.isAnonymous ? AuthType.anonymous : AuthType.email;
  }

  @override
  Future<AppUser> ensureSignedIn() async {
    final existing = _remote.currentAuthUser;
    if (existing != null) {
      final profile = await _remote.fetchProfile(existing.id);
      if (profile != null) return profile;
      return AppUser(
        id: existing.id,
        authType: existing.isAnonymous ? AuthType.anonymous : AuthType.email,
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
  }) => _remote.signInWithEmail(email, password);

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
  }) => _remote.signUpWithEmail(email, password);

  @override
  Future<AppUser> upgradeWithEmail({
    required String email,
    required String password,
  }) => _remote.upgradeWithEmail(email, password);

  AppUser _currentOrAnonymous() =>
      currentUser ?? const AppUser(id: '', authType: AuthType.anonymous);

  @override
  Future<AppUser> signInWithGoogle() => _remote.signInWithGoogleNative();

  @override
  Future<AppUser> signInWithApple() async {
    await _remote.signInWithOAuth(OAuthProvider.apple);
    return _currentOrAnonymous();
  }

  @override
  Future<(AppUser, bool)> upgradeWithGoogle() => _remote.linkOrSignInGoogle();

  @override
  Future<AppUser> upgradeWithApple() async {
    await _remote.linkOAuthIdentity(OAuthProvider.apple);
    return _currentOrAnonymous();
  }

  @override
  Future<AppUser> updateProfile({String? name, String? username}) =>
      _remote.updateProfile(name: name, username: username);

  @override
  Future<void> signOut() => _remote.signOut();

  @override
  Future<void> deleteAccount() => _remote.deleteAccount();
}
