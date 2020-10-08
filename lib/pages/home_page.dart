import 'package:devreg/repository/repository.dart';
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
  bool deviceIsValid = false;

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
              'Validate Your Device',
              style: theme.headline4,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Your Wallet Address:',
              style: theme.headline6.apply(fontSizeDelta: -3),
            ),
            SizedBox(
                width: 200,
                child: Text(
                  '${ethAddress?.hexEip55}',
                  textAlign: TextAlign.center,
                )),
            SizedBox(height: 20),
            deviceIsValid
                ? Text(
                    'Horaayyy',
                    style: TextStyle(color: Colors.green),
                  )
                : Text('Device Status Unknown',
                    style: TextStyle(color: Colors.red)),
            RaisedButton(
              onPressed: () => checkDevice(),
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

  Future<void> checkDevice() async {
    print('Address: ${ethAddress?.hexEip55}');
    QuorumRepository repo = QuorumRepository();
    final owner = await repo.getOwner();
    print('owner: $owner');

    final result = await repo.checkDevice('iPhoneSE');
    print('result: $result');

    setState(() {
      deviceIsValid = result;
    });
  }
}
