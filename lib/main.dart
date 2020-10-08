import 'package:devreg/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet_hd/wallet_hd.dart';

void main() async {
  await DotEnv().load('.env');
  final mnemonic = DotEnv().env['MNEMONIC'] ?? WalletHd.createRandomMnemonic();
  print('mnemonic: $mnemonic');
  runApp(MyApp(mnemonic: mnemonic));
}

class MyApp extends StatelessWidget {
  MyApp({this.mnemonic});
  final String mnemonic;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web3 Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(mnemonic: mnemonic),
    );
  }
}
