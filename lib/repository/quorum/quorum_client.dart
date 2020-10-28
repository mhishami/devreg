import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart' show rootBundle;

class QuorumClient {
  final http.Client httpClient;
  final String baseURL;
  final EthereumAddress contractAddress =
      EthereumAddress.fromHex('0x527930DfF58aA13f63B7F8C5Bb2AE4FC324466ec');

  QuorumClient({http.Client httpClient, String baseURL})
      : httpClient = httpClient ?? http.Client(),
        baseURL = baseURL ?? 'http://139.99.61.203:22000';

  Web3Client getClient() {
    return Web3Client(baseURL, httpClient);
  }

  Future<DeployedContract> getContract() async {
    try {
      final abiCode = await rootBundle.loadString('assets/abi/devreg.json');
      return DeployedContract(
          ContractAbi.fromJson(abiCode, 'DeviceRegistry'), contractAddress);
    } catch (e) {
      print('Error: $e');
      throw (e);
    }
  }

  Future<EthereumAddress> getOwner() async {
    try {
      final contract = await getContract();
      final ownerFun = contract.function('owner');
      final result = await getClient()
          .call(contract: contract, function: ownerFun, params: []);
      return result.first;
    } catch (e) {
      print('Error: $e');
      throw (e);
    }
  }

  Future<bool> checkDevice(EthereumAddress sender, String deviceId) async {
    try {
      print('Check device for "$deviceId"');
      final contract = await getContract();
      final validateFun = contract.function('validate');
      final result = await getClient().call(
          sender: sender,
          contract: contract,
          function: validateFun,
          params: [deviceId]);
      return result.first;
    } catch (e) {
      print('Error: $e');
      throw (e);
    }
  }
}
