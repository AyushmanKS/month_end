import 'dart:math';

class GenerateJoinCode {
  const GenerateJoinCode();

  static const String _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  String call({int length = 6}) {
    final random = Random.secure();
    return List.generate(
      length,
      (_) => _alphabet[random.nextInt(_alphabet.length)],
    ).join();
  }
}
