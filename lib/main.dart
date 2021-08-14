import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qbittorrent_remote_manager/delete_torrent_dialog.dart';

import 'login.dart';
import 'server.dart';
import 'torrent.dart';
import 'utility_functions.dart';
import 'torrent_functions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'qBittorrent Remote Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'qBittorrent Remote Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _title = "qBittorrent Remote Manager";
  List<Torrent> _torrents = [];
  Server _server = Server.failedConnection();
  Timer? _timer;
  bool _pause = false;

  void _logout() async {
    await _server.logout();
    setState(() {
      _torrents.removeRange(0, _torrents.length);
      _title = "qBittorrent Remote Manager";
    });
  }

  @override
  void initState() {
    _timer = new Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_server.connected) {
        List<Torrent> temp = await getTorrents(_server);
        setState(() {_torrents = temp;});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () async {
                Navigator.pop(context);

                final Server server = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ) ?? Server.failedConnection();

                if (server.connected) {
                  List<Torrent> torrents = await getTorrents(server);
                  bool pause = await checkAllTorrents(server, torrents);

                  setState(() {
                    _server = server;
                    _torrents = torrents;
                    _title = server.name!;
                    _pause = pause;
                  });
                }
              },
            ),
            /*ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),*/
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            icon: _pause ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            tooltip: '',
            onPressed: () {
              toggleAll(_server, _torrents);
              _pause = !_pause;  
            },
          ),
        ]
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Cookie: ${_server.cookie}'),
              Expanded(
                child: ListView.builder(
                  itemCount: _torrents.length,
                  itemBuilder: (BuildContext context, int index) {
                    var torrent = _torrents[index];

                    return Dismissible(
                      key: Key(torrent.hash),
                      confirmDismiss: (DismissDirection direction) async {
                        await showDeleteTorrentDialog(context, torrent, _server);
                      },
                      onDismissed: (DismissDirection direction) {},
                      direction: DismissDirection.endToStart,
                      background: Container(color: Colors.red),
                      child: ListTile(
                        title: Text(_torrents[index].name),
                        subtitle: Text(
                          'State: ${torrent.state}\n'
                          'Download: ${formatBytesPerSecond(torrent.dlspeed)}\n'
                          'Upload: ${formatBytesPerSecond(torrent.upspeed)}\n'
                          'Seeds: ${torrent.numSeeds}\n'
                          'Downloaded: ${formatSize((torrent.size * torrent.progress).toInt())} of ${formatSize(torrent.size)}\n'
                          'Progress: ${(torrent.progress * 100).toStringAsFixed(2)}%\n'
                          'ETA: ${formatTime(torrent.eta)}'
                        ),
                        onTap: () {
                          _torrents[index].toggle(_server);
                        },
                      ),
                    );
                  }
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton.icon(
                  onPressed: () async {_logout();},
                  icon: Icon(Icons.logout),
                  label: Text("Logout")
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
