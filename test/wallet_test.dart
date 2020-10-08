import 'package:dotenv/dotenv.dart' show load, clean, env;
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_hd/wallet_hd.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  test('generate address', () async {
    load();
    final mnemonic = env['MNEMONICS'];
    print('mnem: $mnemonic');
    clean();

    // generate our address
    final pk = WalletHd.ethMnemonicToPrivateKey(mnemonic);
    final mapAddr = await WalletHd.getAccountAddress(mnemonic);
    print('ETH: ${mapAddr['ETH']}');

    final url = 'http://localhost:22000';
    final ethClient = Web3Client(url, http.Client());

    var credentials =
        await ethClient.credentialsFromPrivateKey(HEX.encode(pk.privateKey));

    print('ETH: ${await credentials.extractAddress()}');
  });
}
