import 'package:pinenacl/ed25519.dart';

class PinenaclService {
  PrivateKey createKey() {
    final skbob = PrivateKey.generate();
    return skbob;
  }
}
