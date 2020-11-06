import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

class QuorumClient {
  final http.Client httpClient;
  final String baseUrl;

  final EthereumAddress contractAddress =
      EthereumAddress.fromHex('0xaf87694b78C9C38a7Ef5F0807235440Ef5297Da9');

  QuorumClient({http.Client httpClient, String url})
      : httpClient = httpClient ?? http.Client(),
        baseUrl = url ?? 'http://139.99.61.203:22004';

  Future<DeployedContract> getContract() async {
    try {
      final json = await rootBundle.loadString('assets/abi/abi.json');
      return DeployedContract(
          ContractAbi.fromJson(json, 'DeviceRegistry'), contractAddress);
    } catch (e) {
      throw (e);
    }
  }

  Web3Client getClient() {
    return Web3Client(baseUrl, httpClient);
  }

  Future<EthereumAddress> getOwner() async {
    final contract = await getContract();
    final ownerFun = contract.function('owner');
    final result = await getClient()
        .call(contract: contract, function: ownerFun, params: []);
    return result.first;
  }

  Future<bool> verifyDevice(EthereumAddress ethAddress, String deviceId) async {
    final contract = await getContract();
    final verifyFun = contract.function('validate');
    final result = await getClient().call(
        contract: contract,
        function: verifyFun,
        sender: ethAddress,
        params: [deviceId]);
    return result.first;
  }
}
