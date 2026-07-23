import 'package:http/http.dart' as http;
import '../logging/app_logger.dart';

class BackendHealthService {
  BackendHealthService(this._baseUrl, this._apiKey, {http.Client? client})
    : _client = client ?? http.Client();

  final String _baseUrl;
  final String _apiKey;
  final http.Client _client;

  Future<bool> isReachable() async {
    if (_baseUrl.isEmpty) return true;
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/auth/v1/health'),
            headers: {'apikey': _apiKey},
          )
          .timeout(const Duration(seconds: 3));
      return response.statusCode < 500;
    } catch (e) {
      AppLogger.instance.d('Backend health probe inconclusive: $e');
      return true;
    }
  }
}
