import 'package:devreg/repository/quorum/quorum_client.dart';
import 'package:web3dart/web3dart.dart';

class QuorumRepository {
  final QuorumClient client = QuorumClient();

  Future<EthereumAddress> getOwner() async {
    return await client.getOwner();
  }

  Future<bool> verifyDevice(EthereumAddress ethAddress, String deviceId) async {
    return client.verifyDevice(ethAddress, deviceId);
  }
}
