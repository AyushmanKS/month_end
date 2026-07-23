import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../error/app_exception.dart';
import '../logging/app_logger.dart';

abstract class ImageUploadService {
  Future<String> uploadReceipt(String filePath);
}

class CloudinaryImageUploadService implements ImageUploadService {
  CloudinaryImageUploadService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  String get _cloudName => dotenv.maybeGet('CLOUDINARY_CLOUD_NAME') ?? '';
  String get _preset => dotenv.maybeGet('CLOUDINARY_UPLOAD_PRESET') ?? '';

  @override
  Future<String> uploadReceipt(String filePath) async {
    if (_cloudName.isEmpty || _preset.isEmpty) {
      throw const ValidationException('Cloudinary is not configured.');
    }

    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _preset;
    if (kIsWeb) {
      final bytes = await XFile(filePath).readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: 'receipt.jpg'),
      );
    } else {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    }

    AppLogger.instance.i('Uploading receipt image to Cloudinary');
    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final url = json['secure_url'] as String?;
      if (url == null) {
        throw const UnknownException('Upload succeeded but no URL returned.');
      }
      AppLogger.instance.i('Receipt uploaded: $url');
      return url;
    }

    throw NetworkException(
      'Image upload failed (${response.statusCode}).',
      cause: response.body,
    );
  }
}

final imageUploadServiceProvider = Provider<ImageUploadService>((ref) {
  return CloudinaryImageUploadService();
});
