import 'package:flutter/material.dart';
import 'package:pinenacl/ed25519.dart';
import 'package:pinenacl/x25519.dart';
import 'package:secure_storage_explore/flutter_secure_storage_page.dart';
import 'package:secure_storage_explore/services/flutter_secure_storage_service.dart';
import 'package:secure_storage_explore/services/pinenacl_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlutterSecureStoragePage(),
    );
  }
}
