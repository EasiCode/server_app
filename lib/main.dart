import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:server_app/tcp_server.dart';
//import 'package:server_app/service_publisher.dart';
import 'package:server_app/bonsoir_servize.dart';
import 'package:server_app/wifi_direct_server.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'Bonjour Server'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Socket? server;
  int _counter = 0;
  // 1. Create and bind a socket and listen to socket
  static const ip = '127.0.0.1';
  static const port = 22345;
  final server = Server(ip, port);
  final nearbyServer = NearbyServer();
  @override
  void initState() {
    super.initState();
    // 2. Broadcast device info on local network
    _initBonjour(ip, port);

    //listen for data from client

    server.receivedData.listen((messageFromClient) {
      if (kDebugMode) {
        print('Received data of size ${messageFromClient.length}');
      }
      /* final nom = int.parse(messageFromClient);
      setState(() {
        _counter = nom;
      });*/
    });
  }

  //create broadcast service and start broadcasting
  _initBonjour(String ip, int port) async {
    //1. Create broadcast service
    BonsoirService service = BonsoirService(
      name: 'My wonderful service',
      type: AppService.type,
      port: port,
    );

    // 2. And now we can broadcast it :
    BonsoirBroadcast broadcast = BonsoirBroadcast(service: service);
    await broadcast.ready;
    await broadcast.start();
  }

  void _incrementCounter() {
    setState(() {
      _counter--;
      //send data to client
      // server.sendMessage('$_counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many time(s):',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
