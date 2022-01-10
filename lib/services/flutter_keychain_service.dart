import 'package:flutter_keychain/flutter_keychain.dart';

class FlutterKeychainService {
  Future<String> read(String key) async {
    String? value = await FlutterKeychain.get(key: key);
    return value ?? '';
  }

  void write(String key, String value) async {
    await FlutterKeychain.put(key: key, value: value);
  }
}
