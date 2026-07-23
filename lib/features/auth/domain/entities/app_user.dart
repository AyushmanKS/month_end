enum AuthType { anonymous, google, apple, email }

class AppUser {
  const AppUser({
    required this.id,
    required this.authType,
    this.name,
    this.photoUrl,
    this.email,
    this.username,
  });

  final String id;
  final AuthType authType;
  final String? name;
  final String? photoUrl;
  final String? email;
  final String? username;

  bool get isAnonymous => authType == AuthType.anonymous;
  bool get isAuthenticated => !isAnonymous;
  bool get canCreateBucket => true;
  bool get canShareOrJoin => !isAnonymous;
  bool get canReserveUsername => !isAnonymous;
  bool get hasUsername => username != null && username!.isNotEmpty;

  AppUser copyWith({
    String? name,
    String? photoUrl,
    String? email,
    String? username,
    AuthType? authType,
  }) {
    return AppUser(
      id: id,
      authType: authType ?? this.authType,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      authType: _authTypeFrom(json['auth_type'] as String?),
      name: json['name'] as String?,
      photoUrl: json['photo_url'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth_type': authType.name,
      'name': name,
      'photo_url': photoUrl,
      'email': email,
      'username': username,
    };
  }

  static AuthType _authTypeFrom(String? value) {
    return AuthType.values.firstWhere(
      (t) => t.name == value,
      orElse: () => AuthType.anonymous,
    );
  }
}
