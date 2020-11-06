import 'package:devreg/device_registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_hd/wallet_hd.dart';

Future<void> main() async {
  await DotEnv().load('.secret');
  final secret =
      'exile knock awkward insect foil silent close sea panther tackle plate sand'; //DotEnv().env['MNEMONIC'] ?? WalletHd.createRandomMnemonic();
  print('secret: $secret');

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light));
  runApp(MyApp(mnemonic: secret));
}

class MyApp extends StatelessWidget {
  MyApp({this.mnemonic});

  final String mnemonic;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Registration Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DeviceRegistration(mnemonic: mnemonic),
    );
  }
}
