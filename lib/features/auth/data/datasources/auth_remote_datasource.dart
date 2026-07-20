import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../../core/error/app_exception.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/app_user.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _usersTable = 'users';
  static const String _oauthRedirect = 'monthend://login-callback';

  GoTrueClient get _auth => _client.auth;

  User? get currentAuthUser => _auth.currentUser;

  Future<AppUser> signInAnonymously() async {
    try {
      final response = await _auth.signInAnonymously();
      final user = _requireUser(response.user);
      AppLogger.instance.i('Anonymous sign-in: ${user.id}');
      return _syncProfile(user, AuthType.anonymous);
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<AppUser> signInWithEmail(String email, String password) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = _requireUser(response.user);
      return _syncProfile(user, AuthType.email);
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<AppUser> signUpWithEmail(String email, String password) async {
    try {
      final response = await _auth.signUp(email: email, password: password);
      final user = _requireUser(response.user);
      return _syncProfile(user, AuthType.email);
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<AppUser> upgradeWithEmail(String email, String password) async {
    try {
      final response = await _auth.updateUser(
        UserAttributes(email: email, password: password),
      );
      final user = _requireUser(response.user);
      AppLogger.instance.i('Anonymous account upgraded to email: ${user.id}');
      return _syncProfile(user, AuthType.email);
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<void> linkOAuthIdentity(OAuthProvider provider) async {
    try {
      await _auth.linkIdentity(
        provider,
        redirectTo: kIsWeb ? null : _oauthRedirect,
      );
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<void> signInWithOAuth(OAuthProvider provider) async {
    try {
      await _auth.signInWithOAuth(
        provider,
        redirectTo: kIsWeb ? null : _oauthRedirect,
      );
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<AppUser> updateProfile({String? name, String? username}) async {
    try {
      final user = _requireUser(currentAuthUser);
      final payload = <String, dynamic>{'id': user.id};
      if (name != null) payload['name'] = name;
      if (username != null) payload['username'] = username;
      final row = await _client
          .from(_usersTable)
          .upsert(payload)
          .select()
          .single();
      return AppUser.fromJson(row);
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<AppUser?> fetchProfile(String id) async {
    try {
      final row = await _client
          .from(_usersTable)
          .select()
          .eq('id', id)
          .maybeSingle();
      if (row == null) return null;
      return AppUser.fromJson(row);
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<AppUser> _syncProfile(User user, AuthType authType) async {
    final resolvedType = _resolveAuthType(user, authType);
    final payload = {
      'id': user.id,
      'auth_type': resolvedType.name,
      'email': user.email,
    };
    final row = await _client
        .from(_usersTable)
        .upsert(payload)
        .select()
        .single();
    return AppUser.fromJson(row);
  }

  AuthType _resolveAuthType(User user, AuthType fallback) {
    if (user.isAnonymous) return AuthType.anonymous;
    final providers = user.appMetadata['providers'];
    if (providers is List) {
      if (providers.contains('google')) return AuthType.google;
      if (providers.contains('apple')) return AuthType.apple;
      if (providers.contains('email')) return AuthType.email;
    }
    return fallback;
  }

  User _requireUser(User? user) {
    if (user == null) {
      throw ErrorHandler.map(
        const AuthException('No authenticated user returned.'),
      );
    }
    return user;
  }
}
