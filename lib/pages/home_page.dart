import 'package:flutter/material.dart';
import 'package:wallet_hd/wallet_hd.dart';
import 'package:web3dart/web3dart.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.mnemonic}) : super(key: key);
  final String mnemonic;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EthPrivateKey privKey;
  EthereumAddress ethAddress;

  @override
  void initState() {
    super.initState();
    prepareAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device Registry')),
      body: buildContent(context),
    );
  }

  buildContent(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.all(22),
      width: double.infinity,
      child: Card(
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome...',
              style: theme.headline4,
            ),
            Text('Your Wallet Address:'),
            SizedBox(width: 250, child: Text('${ethAddress?.hexEip55}')),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () => print('You clicked me!'),
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Check Authorization'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> prepareAddress() async {
    // print('prepareAdress::mnemonic: ${widget.mnemonic}');
    final _privKey = WalletHd.ethMnemonicToPrivateKey(widget.mnemonic);
    final _addr = await _privKey.extractAddress();

    setState(() {
      privKey = _privKey;
      ethAddress = _addr;
    });
    return true;
  }
}
