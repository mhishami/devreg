import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:devreg/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
  String deviceId = '';

  bool deviceIsValid = false;
  bool hasValidated = false;
  String errorMessage = 'Device Is Unregistered';

  @override
  void initState() {
    super.initState();
    prepareAddress();
    initDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Device Registry')),
      backgroundColor: Colors.grey[100],
      body: SafeArea(child: buildContent(context)),
    );
  }

  buildContent(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Validate Your Device',
              style: theme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Your Wallet Address:',
              style: theme.headline6.apply(fontSizeDelta: -8),
            ),
            SizedBox(
              width: 200,
              child: Text(
                '${ethAddress?.hexEip55}',
                textAlign: TextAlign.center,
                // overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'DeviceId:',
              style: theme.headline6.apply(fontSizeDelta: -8),
            ),
            QrImage(
              data: deviceId, //'idevice://deviceId?location=IIUM',
              size: 200,
            ),
            SizedBox(
              width: 200,
              child: Text(
                deviceId,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            deviceIsValid
                ? Text(
                    'Device Is Registered',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  )
                : Text(hasValidated ? errorMessage : 'Device Status Unknown',
                    style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
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

    final result = await repo.checkDevice(ethAddress, deviceId);
    print('result: $result');

    setState(() {
      deviceIsValid = result;
      hasValidated = true;
    });
  }

  Future<void> initDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      setState(() {
        deviceId = iosInfo.identifierForVendor;
      });
    } else {
      final androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceId = androidInfo.androidId;
      });
    }
  }
}
