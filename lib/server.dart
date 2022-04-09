import 'dart:async';
import 'dart:io';

import 'dart:typed_data';

class Server {
  Server() {
    _sendData = StreamController<String>.broadcast();
    sendData = _sendData.stream;
    inito();
  }
  late StreamController<String> _sendData;
  late Stream<String> sendData;
  Socket? _client;
  Future<void> inito() async {
    // bind the socket server to an address and port
    final server = await ServerSocket.bind("127.0.0.1", 18910);

    // listen for connections from client(s)
    server.listen((client) {
      handleConnection(client);
    });
  }

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
