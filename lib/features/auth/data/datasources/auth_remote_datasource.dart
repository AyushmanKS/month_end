import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  bool _googleInitialized = false;

  String get _googleWebClientId =>
      dotenv.maybeGet('GOOGLE_WEB_CLIENT_ID') ?? '';
  String get _googleIosClientId =>
      dotenv.maybeGet('GOOGLE_IOS_CLIENT_ID') ?? '';

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
      AppLogger.instance.i('OAuth link: launching ${provider.name}');
      final launched = await _auth
          .linkIdentity(
            provider,
            redirectTo: kIsWeb ? null : _oauthRedirect,
          )
          .timeout(const Duration(seconds: 30));
      AppLogger.instance.i('OAuth link: browser launched=$launched');
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<void> signInWithOAuth(OAuthProvider provider) async {
    try {
      AppLogger.instance.i('OAuth sign-in: launching ${provider.name}');
      final launched = await _auth
          .signInWithOAuth(
            provider,
            redirectTo: kIsWeb ? null : _oauthRedirect,
          )
          .timeout(const Duration(seconds: 30));
      AppLogger.instance.i('OAuth sign-in: browser launched=$launched');
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<String> _googleIdToken() async {
    final signIn = GoogleSignIn.instance;
    if (!_googleInitialized) {
      await signIn.initialize(
        serverClientId: _googleWebClientId,
        clientId: (!kIsWeb && Platform.isIOS) ? _googleIosClientId : null,
      );
      _googleInitialized = true;
    }
    AppLogger.instance.i('Google native: authenticating');
    final account = await signIn.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const AuthException('Google did not return an ID token.');
    }
    AppLogger.instance.i('Google native: got id token');
    return idToken;
  }

  Future<(AppUser user, bool signedIntoExisting)> linkOrSignInGoogle() async {
    try {
      final idToken = await _googleIdToken();
      try {
        await _auth.linkIdentityWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
        );
        AppLogger.instance.i('Google native: identity linked');
        final user = await _syncProfile(
            _requireUser(currentAuthUser), AuthType.google);
        return (user, false);
      } on AuthApiException catch (e) {
        if (e.code != 'identity_already_exists') rethrow;
        AppLogger.instance
            .i('Google native: already linked, signing into existing account');
        final response = await _auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
        );
        final user = await _syncProfile(
            _requireUser(response.user), AuthType.google);
        return (user, true);
      }
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<AppUser> signInWithGoogleNative() async {
    try {
      final idToken = await _googleIdToken();
      final response = await _auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
      final user = _requireUser(response.user);
      return _syncProfile(user, AuthType.google);
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

  Future<void> setAuthType(
    String id,
    AuthType type,
    String? email, {
    String? name,
    String? photoUrl,
  }) async {
    try {
      await _client.from(_usersTable).upsert({
        'id': id,
        'auth_type': type.name,
        'email': ?email,
        'name': ?name,
        'photo_url': ?photoUrl,
      });
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
