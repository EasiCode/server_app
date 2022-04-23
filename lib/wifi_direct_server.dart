// ignore_for_file: avoid_print

import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

late NearbyService nearbyService;

class NearbyServer {
  NearbyServer() {
    init();
    //onButtonClicked(device);
  }
  void init() async {
    nearbyService = NearbyService();

    await nearbyService.init(
        serviceType: 'mpconn',
        strategy: Strategy.P2P_CLUSTER,
        callback: (isRunning) async {
          if (isRunning) {
            await nearbyService.stopAdvertisingPeer();
            //await Future.delayed(const Duration(microseconds: 200));
            await nearbyService.startAdvertisingPeer();
            print("advertising Peer...");
          }
        });
  }
}
