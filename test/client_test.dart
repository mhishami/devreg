import 'package:devreg/repository/quorum/quorum_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test client', () async {
    QuorumClient quorum = QuorumClient();
    final client = quorum.getClient();
    print('client: ${await client.getBlockNumber()}');
  });
}
