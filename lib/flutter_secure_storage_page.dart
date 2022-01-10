import 'package:flutter/material.dart';
import 'package:pinenacl/ed25519.dart';
import 'package:pinenacl/x25519.dart';
import 'package:secure_storage_explore/flutter_keychain_page.dart';

import 'services/flutter_secure_storage_service.dart';
import 'services/pinenacl_service.dart';

class FlutterSecureStoragePage extends StatefulWidget {
  const FlutterSecureStoragePage({Key? key}) : super(key: key);

  @override
  _FlutterSecureStoragePageState createState() =>
      _FlutterSecureStoragePageState();
}

class _FlutterSecureStoragePageState extends State<FlutterSecureStoragePage> {
  List benchmarkValue = [];
  String data = '';
  Uint8List? encrypt;
  final hex = HexCoder.instance;

  void Function()? write() {
    ///create new private key
    PrivateKey privateKey = PinenaclService().createKey();

    ///create sealedBox with public key
    final sealedBox = SealedBox(privateKey.publicKey);

    ///encrypt text with sealedBox
    final encrypted = sealedBox.encrypt('saddam'.codeUnits.toUint8List());

    ///save to flutter_secure_storage
    FlutterSecureStorageService()
        .write('keySaddam', String.fromCharCodes(privateKey));

    ///update encrypt text
    setState(() {
      encrypt = encrypted;
    });

    print('private key : ' + privateKey.toString());
    print('enrypt text : ' + encrypted.toString());
  }

  Future<void Function()?>? read() async {
    ///read private key from flutter_secure_storage
    String privateKey = await FlutterSecureStorageService().read('keySaddam');

    ///convert data private key from flutter_secure_storage,
    ///default type data is String and we want to convert PrivateKey type
    PrivateKey privateKeyDecode =
        PrivateKey(Uint8List.fromList(privateKey.codeUnits));

    ///create sealedBox with privateKey
    final sealedBox = SealedBox(privateKeyDecode);

    ///decrypt encrypt data with sealedBox
    final decrypted = sealedBox.decrypt(encrypt!);

    setState(() {});

    print(
        'private key : ' + Uint8List.fromList(privateKey.codeUnits).toString());
    print(hex.encode(privateKeyDecode.publicKey));
    print(String.fromCharCodes(decrypted));
  }

  Future<void Function()?>? benchmark() async {
    benchmarkValue.clear();
    setState(() {});
    int iteration = 10;

    List avg = [];

    for (var i = 0; i < iteration; i++) {
      DateTime writeStart = DateTime.now();
      write();
      DateTime writeEnd = DateTime.now();
      avg.add(writeEnd.difference(writeStart).inMicroseconds / 1000000);
      print('=======================================================');
    }

    print('write : ' + ((avg.reduce((a, b) => a + b)) / avg.length).toString());
    benchmarkValue.add(((avg.reduce((a, b) => a + b)) / avg.length).toString());
    avg.clear();

    for (var i = 0; i < iteration; i++) {
      DateTime writeStart = DateTime.now();
      await read();
      DateTime writeEnd = DateTime.now();
      avg.add(writeEnd.difference(writeStart).inMicroseconds / 1000000);
      print('=======================================================');
    }

    print('read : ' + ((avg.reduce((a, b) => a + b)) / avg.length).toString());
    benchmarkValue.add(((avg.reduce((a, b) => a + b)) / avg.length).toString());
    avg.clear();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_secure_storage'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FlutterKeychainPage(),
                ),
              );
            },
            icon: const Icon(Icons.swap_vert),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              data,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: write,
                  child: const Text('Write'),
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: read,
                  child: const Text('Read'),
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: benchmark,
                  child: const Text('Benchmark'),
                ),
              ],
            ),
            if (benchmarkValue.length > 1)
              Text(
                'Benchmark\n' +
                    'write : ${benchmarkValue.first}\n' +
                    'read : ${benchmarkValue.last}',
              ),
          ],
        ),
      ),
    );
  }
}
