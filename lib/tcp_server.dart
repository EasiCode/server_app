// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'dart:typed_data';

class Server {
  Server(this.ip, this.port) {
    _receivedData = StreamController<Uint8List>.broadcast();
    receivedData = _receivedData.stream;
    init();
  }

  final String ip;
  final int port;

  late StreamController<Uint8List> _receivedData;
  late Stream<Uint8List> receivedData;
  Socket? _client;

  // ...........................................................................
  //ServerSocket? _server;

  Future<void> init() async {
    // bind the socket server to an address and port
    final server = await ServerSocket.bind(ip, port, shared: true);

    //listen for connection from client
    server.listen((_) {
      handleConnection(_);
    });
  }

  // Accept Connection from client
  void handleConnection(Socket client) {
    _client = client;
    print('Connection from Client:'
        ' ${client.remoteAddress.address}:${client.remotePort}');

    // listen for events from the client
    client.listen(
      // handle data from the client
      (Uint8List data) async {
        // final messageFromClient = String.fromCharCodes(data);
        // final nom = int.parse(messageFromClient);
        // _receivedData.add(messageFromClient);
        // print('client: $nom');
        _sendAcknowledgmentOnStopByteReceived(data);
        _receivedData.add(data);
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

  // ...........................................................................
  _sendAcknowledgmentOnStopByteReceived(Uint8List buffer) {
    // Iterate all bytes in buffer, check if there is a stop byte.
    // If stop byte is found, send acknowledgement.
    for (int byte in buffer) {
      const stopByte = 0xAA;
      if (byte == stopByte) {
        _sendAcknowledgement();
      }
    }
  }

  // ...........................................................................
  _sendAcknowledgement() {
    _client?.write('Acknowledgement');
  }

  //handling data transfer to client
  Future<void> sendMessage(String message) async {
    print('server: $message');
    _client?.write(message);
    await _client?.flush();
  }
}
