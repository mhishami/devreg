import 'package:devreg/repository/quorum/quorum_client.dart';
import 'package:web3dart/web3dart.dart';

class QuorumRepository {
  final QuorumClient quorumClient = QuorumClient();

  Future<bool> checkDevice(EthereumAddress sender, String deviceId) async {
    return await quorumClient.checkDevice(sender, deviceId);
  }

  Future<EthereumAddress> getOwner() async {
    return await quorumClient.getOwner();
  }
}
