import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> watchUser();

  AppUser? get currentUser;

  Future<AppUser> ensureSignedIn();

  Future<AppUser> signInAnonymously();

  Future<AppUser> signInWithGoogle();

  Future<AppUser> signInWithApple();

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<AppUser> upgradeWithEmail({
    required String email,
    required String password,
  });

  Future<AppUser> upgradeWithGoogle();

  Future<AppUser> upgradeWithApple();

  Future<AppUser> updateProfile({String? name, String? username});

  Future<void> signOut();
}
