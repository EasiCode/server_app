// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';

import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

class NearbyServer {
  // ...........................................................................
  NearbyServer() {
    _init();
  }

  // ...........................................................................
  void _init() async {
    _nearbyService = NearbyService();
    await _advertize();
    _listenForData();
  }

  // ...........................................................................
  Future<void> _advertize() async {
    await _nearbyService.init(
      serviceType: 'mpconn',
      strategy: Strategy.P2P_CLUSTER,
      callback: (isRunning) async {
        if (isRunning) {
          await _nearbyService.stopAdvertisingPeer();
          await _nearbyService.startAdvertisingPeer();
          print("advertising Peer...");
        }
      },
    );
  }

  // ...........................................................................
  _listenForData() {
    _nearbyService.dataReceivedSubscription(callback: (data) {
      _nearbyService.sendMessage(data['deviceId'], 'Acknowledgement');
    });
  }

  // ...........................................................................
  late NearbyService _nearbyService;
}
