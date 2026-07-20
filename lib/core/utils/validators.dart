class Validators {
  const Validators._();

  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _username = RegExp(r'^[a-z0-9_]{3,20}$');
  static final RegExp _joinCode = RegExp(r'^[A-Z0-9]{6}$');

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!_email.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Use at least 8 characters';
    return null;
  }

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) return 'Username is required';
    if (!_username.hasMatch(value)) {
      return '3-20 chars, lowercase letters, numbers, underscore';
    }
    return null;
  }

  static String? joinCode(String? value) {
    if (value == null || value.isEmpty) return 'Enter a join code';
    if (!_joinCode.hasMatch(value.toUpperCase())) {
      return 'Codes are 6 characters (A-Z, 0-9)';
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.isEmpty) return 'Enter an amount';
    final parsed = double.tryParse(value);
    if (parsed == null) return 'Enter a valid number';
    if (parsed <= 0) return 'Amount must be greater than zero';
    return null;
  }
}
