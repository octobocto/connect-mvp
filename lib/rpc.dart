import 'dart:async';

import 'package:connectrpc/protocol/grpc.dart';
import 'package:mvp_connect/gen/cusf/mainchain/v1/validator.connect.client.dart';
import 'package:mvp_connect/gen/cusf/mainchain/v1/validator.pb.dart';

class RPC {
  late final ValidatorServiceClient validator;

  RPC({required Transport transport}) {
    validator = ValidatorServiceClient(transport);
    startConnectionTimer();
  }

  Future<int> ping() async {
    final res = await validator.getChainTip(GetChainTipRequest());
    return res.blockHeaderInfo.height;
  }

  // responsible for pinging the node every x seconds,
  // so we can update the UI immediately when the connection drops/begins
  Timer? _connectionTimer;
  Future<void> startConnectionTimer() async {
    // Cancel any existing timer before starting a new one
    _connectionTimer?.cancel();

    _connectionTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      print('pinging');
      try {
        await ping();
      } catch (e) {
        print('error pinging: $e');
      }
    });
  }
}
