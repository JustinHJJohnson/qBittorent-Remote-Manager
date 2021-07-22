import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qbittorrent_remote/utility_functions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'qBittorrent Remote'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _cookie = "";
  String _torrent = "";
  final _formKey = GlobalKey<FormState>();
  final _ipControlller = TextEditingController();
  final _portControlller = TextEditingController();
  final _usernameControlller = TextEditingController();
  final _passwordControlller = TextEditingController();

  Future<String> _login(String baseURL, String username, String password) async {
    // get auth cookie by logging in
    var url = Uri.parse('$baseURL/api/v2/auth/login');
    print('request URL is $baseURL/api/v2/auth/login');
    dynamic response;
    try {
      print('baseURL is $baseURL');
      print('username and pass is username=$username&password=$password');
      response = await http.post(url, headers: {'Referer': baseURL}, body: {'username' : username, 'password': password});
    } on SocketException catch (_) {
      showCustomSnackBar(context, 'Failed to login');
      return "Failed";
    }
    if (response.body == "Fails.") {
      print('Failed to login with code ${response.statusCode}');
      print('body: ${response.body}');
      showCustomSnackBar(context, 'Invalid login details');
      return "Failed";
    }
    else if (response.statusCode == 403) {
      print('Failed to login due to too many repeated login attempts');
      showCustomSnackBar(context, 'Failed to login due to too many repeated login attempts');
      return "Failed";
    }
    else if (response.statusCode == 400) {
      print('Failed with a code of 400');
      showCustomSnackBar(context, 'Failed with a code of 400');
      return "Failed";
    }

    showCustomSnackBar(context, 'Login successful');
    print('Response 1 status: ${response.statusCode}');
    print('Response 1 body: ${response.body}');
    print('Response 1 headers: ${response.headers}');


    // Extract the cookie from the response header for auth in future requests
    var rawCookieHeader = response.headers["set-cookie"]!;
    RegExp pattern = RegExp(r'SID=(\S+);');
    final cookieMatch = pattern.firstMatch(rawCookieHeader)!;
    final cookie = cookieMatch.group(1)!;
    print("Cookie is $cookie");
    return cookie;
  }

  Future<List<Map<String, dynamic>>> _getTorrents(String baseURL, String cookie) async {
    // Get info on all current torrents
    var url2 = Uri.parse('$baseURL/api/v2/torrents/info');
    var response2 = await http.post(url2, headers: {'Cookie': 'SID=$cookie'});
    print('Response 2 status: ${response2.statusCode}');
    print('Response 2 body: ${response2.body}');

    // Split to JSON data into seperate torrents and decodes them
    RegExp torrentPattern = RegExp(r'({.+?}).');
    Iterable<RegExpMatch> torrentMatches = torrentPattern.allMatches(response2.body);
    List<Map<String, dynamic>> torrents = [];
    for (var torrent in torrentMatches) torrents.add(jsonDecode(torrent.group(1)!));
    
    print('Number of torrents is ${torrents.length}');

    return torrents;
  }

  Future<void> _testGet(String ip, String port, String username, String password) async {
    final String baseURL = 'http://$ip:$port';
    final String cookie = await _login(baseURL, username, password);
    if (cookie == "Failed") 
    {
      setState(() {_cookie = ""; _torrent = "";});
      return;
    }
    List<Map<String, dynamic>> torrents = await _getTorrents(baseURL, cookie);

    String name = "";
    
    for (var torrent in torrents) {
      print(torrent['name']);
      name += '${torrent['name']}\n';
    }

    setState(() {_cookie = cookie; _torrent = name;});

    await http.post(Uri.parse('$baseURL/api/v2/auth/logout'));
  }

  @override
  Widget build(BuildContext context) {
    _ipControlller.text = "192.168.0.91";
    _portControlller.text = "8080";
    _usernameControlller.text = "admin";
    _passwordControlller.text = "Qywter101";
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Cookie: $_cookie'),
              Text('Most recent torrent is:'),
              Text('$_torrent'),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Flexible(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(hintText: "IP"),
                              controller: _ipControlller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an IP';
                                }
                                return null;
                              },                          
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(hintText: "Port"),
                              controller: _portControlller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a port';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "Username"),
                      controller: _usernameControlller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },                          
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "Password"),
                      controller: _passwordControlller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      }
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate())
                          {
                            _testGet(
                              _ipControlller.text,
                              _portControlller.text,
                              _usernameControlller.text,
                              _passwordControlller.text
                            );
                          }
                        },
                        icon: Icon(Icons.save),
                        label: Text("Login")
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
