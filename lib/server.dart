// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'dart:typed_data';

class Server {
  Server(this.ip, this.port) {
    _sendData = StreamController<String>.broadcast();
    sendData = _sendData.stream;
    init();
  }

  final String ip;
  final int port;

  late StreamController<String> _sendData;
  late Stream<String> sendData;
  Socket? _client;

  // ...........................................................................
  ServerSocket? _server;

  Future<void> init() async {
    // bind the socket server to an address and port
    _server = await ServerSocket.bind(ip, port, shared: true)
      ..listen((client) {
        handleConnection(client);
      });
  }

  // Accept Connection
  void handleConnection(Socket client) {
    _client = client;
    print('Connection from Client:'
        ' ${client.remoteAddress.address}:${client.remotePort}');

    // listen for events from the client
    client.listen(
      // handle data from the client
      (Uint8List data) async {
        final messageFromClient = String.fromCharCodes(data);
        final nom = int.parse(messageFromClient);
        _sendData.add(messageFromClient);
        print('client: $nom');
      },

      // handle errors
      onError: (error) {
        print(error);
        _client = null;
        client.close();
      },

      // handle the client closing the connection
      onDone: () {
        print('Client left');
        _client = null;
        client.close();
      },
    );
  }

  Future<void> sendMessage(String message) async {
    print('server: $message');
    _client?.write(message);
  }
}
