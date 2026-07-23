import 'dart:convert';
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

  String _oauthRedirectTarget() {
    if (!kIsWeb) return _oauthRedirect;
    final base = Uri.base;
    return '${base.origin}${base.path}';
  }

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
          .linkIdentity(provider, redirectTo: _oauthRedirectTarget())
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
          .signInWithOAuth(provider, redirectTo: _oauthRedirectTarget())
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
      final claims = _decodeIdToken(idToken);
      try {
        await _auth.linkIdentityWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
        );
        AppLogger.instance.i('Google native: identity linked');
        final user = await _syncProfile(
          _requireUser(currentAuthUser),
          AuthType.google,
          name: _claimName(claims),
          photoUrl: _claimPhoto(claims),
        );
        return (user, false);
      } on AuthApiException catch (e) {
        if (e.code != 'identity_already_exists') rethrow;
        AppLogger.instance.i(
          'Google native: already linked, signing into existing account',
        );
        final response = await _auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
        );
        final user = await _syncProfile(
          _requireUser(response.user),
          AuthType.google,
          name: _claimName(claims),
          photoUrl: _claimPhoto(claims),
        );
        return (user, true);
      }
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<AppUser> signInWithGoogleNative() async {
    try {
      final idToken = await _googleIdToken();
      final claims = _decodeIdToken(idToken);
      final response = await _auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
      final user = _requireUser(response.user);
      return _syncProfile(
        user,
        AuthType.google,
        name: _claimName(claims),
        photoUrl: _claimPhoto(claims),
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

  Future<void> deleteAccount() async {
    try {
      await _client.rpc('delete_account');
      await _auth.signOut();
    } catch (e, s) {
      throw ErrorHandler.map(e, s);
    }
  }

  Future<AppUser> _syncProfile(
    User user,
    AuthType authType, {
    String? name,
    String? photoUrl,
  }) async {
    final resolvedType = _resolveAuthType(user, authType);
    final resolvedName = name ?? _profileName(user);
    final resolvedPhoto = photoUrl ?? _profilePhoto(user);
    final payload = {
      'id': user.id,
      'auth_type': resolvedType.name,
      'email': user.email,
      'name': ?resolvedName,
      'photo_url': ?resolvedPhoto,
    };
    final row = await _client
        .from(_usersTable)
        .upsert(payload)
        .select()
        .single();
    return AppUser.fromJson(row);
  }

  Map<String, dynamic> _decodeIdToken(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length != 3) return const {};
      final decoded = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final map = jsonDecode(decoded);
      return map is Map<String, dynamic> ? map : const {};
    } catch (_) {
      return const {};
    }
  }

  String? _claimName(Map<String, dynamic> claims) {
    final name = (claims['name'] ?? claims['full_name']) as String?;
    return (name != null && name.isNotEmpty) ? name : null;
  }

  String? _claimPhoto(Map<String, dynamic> claims) {
    final photo = (claims['picture'] ?? claims['avatar_url']) as String?;
    return (photo != null && photo.isNotEmpty) ? photo : null;
  }

  String? _profileName(User user) {
    final meta = user.userMetadata ?? const {};
    final metaName = (meta['full_name'] ?? meta['name']) as String?;
    if (metaName != null && metaName.isNotEmpty) return metaName;
    return _identityValue(user, const ['full_name', 'name']);
  }

  String? _profilePhoto(User user) {
    final meta = user.userMetadata ?? const {};
    final metaPhoto = (meta['avatar_url'] ?? meta['picture']) as String?;
    if (metaPhoto != null && metaPhoto.isNotEmpty) return metaPhoto;
    return _identityValue(user, const ['avatar_url', 'picture']);
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
