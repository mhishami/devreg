import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:devreg/repository/repository.dart';
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
  String _deviceId = '';

  String _deviceStatus = 'unknown';
  bool _deviceIsValid = false;

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
            _prepareHeader(_theme),
            SizedBox(height: 20),
            _buildQrCode(_theme),
            SizedBox(height: 20),
            Text('Device Status:'),
            _showTextStatus(_theme),
            SizedBox(height: 20),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () => checkDevice(),
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
        _deviceId = androidInfo.androidId;
      });
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      setState(() {
        _deviceId = iosInfo.identifierForVendor;
      });
    }
  }

  Future<void> initializeKeys() async {
    print('mnemonic: ${widget.mnemonic}');
    final privKey = WalletHd.ethMnemonicToPrivateKey(widget.mnemonic);
    final addr = await privKey.extractAddress();

    setState(() {
      _ethAddress = addr;
      _privateKey = privKey;
    });
  }

  Future<void> checkDevice() async {
    QuorumRepository repo = QuorumRepository();
    final owner = await repo.getOwner();
    print('Checking Owner: $owner');
    print('DeviceID: $_deviceId');
    final verified = await repo.verifyDevice(_ethAddress, _deviceId);
    print('Device is Verified: $verified');

    setState(() {
      _deviceStatus = 'checked';
      _deviceIsValid = verified;
    });
  }

  _prepareHeader(TextTheme theme) {
    return Container(
      child: Column(
        children: [
          Text(
            'Validate Your Device',
            style: theme.headline5,
          ),
          Text('Your Address:'),
          SizedBox(
            width: 250,
            child: Text(
              '${_ethAddress?.hexEip55}',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  _buildQrCode(TextTheme theme) {
    return Container(
      child: Column(
        children: [
          QrImage(
            data: '$_deviceId',
            size: 250,
          ),
          Text('DeviceID:'),
          SizedBox(
              width: 250,
              child: Text(
                '$_deviceId',
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  _showTextStatus(TextTheme theme) {
    return _deviceIsValid
        ? Text('Device is Registered',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ))
        : Text(
            _deviceStatus == 'unknown'
                ? 'Status Unknown'
                : 'Device Is Unregistered',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: _deviceStatus == 'unknown' ? Colors.orange : Colors.red),
          );
  }
}
