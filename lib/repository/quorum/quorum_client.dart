import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

class QuorumClient {
  final http.Client httpClient;
  final String baseURL;

  QuorumClient({http.Client httpClient, String baseURL})
      : httpClient = httpClient ?? http.Client(),
        baseURL = baseURL ?? 'http://139.99.61.203:22000';

  Web3Client getClient() {
    return Web3Client(baseURL, httpClient);
  }
}
