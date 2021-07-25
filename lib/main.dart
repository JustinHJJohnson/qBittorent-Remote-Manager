import 'package:flutter/material.dart';

import 'login.dart';
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
  String _cookie = "";
  List<Map<String, dynamic>> _torrents = [];

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

                final Map<String, String> info = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ) ?? {};


                if (info.isNotEmpty) {
                  List<Map<String, dynamic>> torrents = await getTorrents(
                    info['baseURL']!,
                    info['cookie']!
                  );

                  setState(() {
                    _torrents = torrents;
                    _title = info['name']!;
                    _cookie = info['cookie']!;
                  });
                }
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Cookie: $_cookie'),
              Expanded(
                child: ListView.builder(
                  itemCount: _torrents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(_torrents[index]['name']),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
