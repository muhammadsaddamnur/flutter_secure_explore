import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageService {
  // Create storage
  final storage = const FlutterSecureStorage();

  Future<String> read(String key) async {
    String? value = await storage.read(key: key);
    return value ?? '';
  }

  void write(String key, String value) async {
    await storage.write(key: key, value: value);
  }
}
