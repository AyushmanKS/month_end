import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../error/app_exception.dart';

class FxService {
  const FxService();

  Future<double> rate(String from, String to) async {
    if (from == to) return 1;
    try {
      final response = await http
          .get(Uri.parse('https://open.er-api.com/v6/latest/$from'))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw const NetworkException('Could not fetch exchange rates.');
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final rates = body['rates'] as Map<String, dynamic>?;
      final value = rates?[to];
      if (value is num && value > 0) return value.toDouble();
      throw const NetworkException(
        'Exchange rate unavailable for this currency.',
      );
    } on AppException {
      rethrow;
    } catch (_) {
      throw const NetworkException('Could not fetch exchange rates.');
    }
  }
}

final fxServiceProvider = Provider<FxService>((ref) => const FxService());
