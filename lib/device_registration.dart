import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet_hd/wallet_hd.dart';
import 'package:web3dart/web3dart.dart';

class DeviceRegistration extends StatefulWidget {
  DeviceRegistration({Key key, this.mnemonic}) : super(key: key);
  final String mnemonic;

  @override
  _DeviceRegistrationState createState() => _DeviceRegistrationState();
}

class _DeviceRegistrationState extends State<DeviceRegistration> {
  EthPrivateKey _privateKey;
  EthereumAddress _ethAddress;
  String deviceId = '';

  @override
  void initState() {
    super.initState();
    initializeKeys();
    prepareDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(child: _buildContent(context)));
  }

  _buildContent(BuildContext context) {
    final _theme = Theme.of(context).textTheme;
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Validate Your Device',
              style: _theme.headline5,
            ),
            Text('Your Address:'),
            SizedBox(
              width: 250,
              child: Text(
                '${_ethAddress?.hexEip55}',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            // show QRCode
            QrImage(
              data: '$deviceId',
              size: 250,
            ),
            Text('DeviceID:'),
            SizedBox(
                width: 250,
                child: Text(
                  '$deviceId',
                  textAlign: TextAlign.center,
                )),
            SizedBox(height: 20),
            Text('Device Status:'),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () => null,
              child: Text('Check Authorization'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> prepareDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceId = androidInfo.androidId;
      });
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      setState(() {
        deviceId = iosInfo.identifierForVendor;
      });
    }
  }

  Future<void> initializeKeys() async {
    final privKey = WalletHd.ethMnemonicToPrivateKey(widget.mnemonic);
    final addr = await privKey.extractAddress();

    setState(() {
      _ethAddress = addr;
      _privateKey = privKey;
    });
  }
}
