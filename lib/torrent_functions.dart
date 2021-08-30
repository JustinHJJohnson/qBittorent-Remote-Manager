/// This file holds all functions that operate on multiple/all torrents
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qbittorrent_remote_manager/searchResult.dart';

import 'server.dart';
import 'torrent.dart';

/// Get all the details on all the current torrents at [baseURL] with [cookie]
Future<List<Torrent>> getTorrents(Server server) async {
  // Get info on all current torrents
  var url = Uri.parse('${server.url!}/api/v2/torrents/info');
  var response = await http.post(url, headers: {'Cookie': server.cookie!});
  //print('Get Torrent Response status: ${response2.statusCode}');
  //print('Get Torrent Response body: ${response2.body}');     

  List<Torrent> torrents = [];

  // Decode the torrents and convert them to torrent objects
  dynamic torrentsJson = jsonDecode(response.body);
  for (var torrent in torrentsJson) torrents.add(Torrent.fromJson(torrent));
    
  //print('Number of torrents is ${torrents.length}');

  return torrents;
}

/// Check if any torrents are unpaused and returns true if so
bool checkAllTorrents(Server server, List<Torrent> torrents) {
  bool pause = false;

  for (Torrent torrent in torrents) {
    if (torrent.state != 'pausedDL' && torrent.state != 'pausedUP') {
      pause = true;
      break;
    }
  }

  return pause;
}

/// Pause or resume all torrents based on current torrents states
void toggleAll(Server server, List<Torrent> torrents) async {
  bool pause = checkAllTorrents(server, torrents);

  if (server.connected) {
    if (pause) {
      var response = await http.post(
        Uri.parse('${server.url}/api/v2/torrents/pause'),
        headers: {'Cookie': server.cookie!},
        body: {'hashes': 'all'}
      );
      print('${response.body}');
    }
    else {
      var response = await http.post(
        Uri.parse('${server.url}/api/v2/torrents/resume'),
        headers: {'Cookie': server.cookie!},
        body: {'hashes': 'all'}
      );
      print('${response.body}');
    }
  }
}

Future<int> startSearch(Server server, String pattern) async {
  var response = await http.post(
    Uri.parse('${server.url}/api/v2/search/start'),
    headers: {'Cookie': server.cookie!},
    body: {
      'pattern': pattern,
      'plugins' : 'all',
      'category' : 'all',
    }
  );

  String body = response.body;
  int searchID = int.parse(body.substring(6, body.length - 1));
  print('$body');
  print('$searchID');

  return Future<int>.value(searchID);
}

Future<List<SearchResult>> getSearchResults(Server server, int searchID) async {
  var response = await http.post(
    Uri.parse('${server.url}/api/v2/search/results'),
    headers: {'Cookie': server.cookie!},
    body: {'id': '$searchID'}
  );

  dynamic responseDecoded = jsonDecode(response.body);
  //dynamic results = jsonDecode(response.body);
  List<SearchResult> output = [];

  switch (response.statusCode) {
    case 404: print('Search task not found'); break;
    case 409: print('Offset is too big/small'); break;
    case 200: for (var result in responseDecoded['results']) output.add(SearchResult.fromJson(result)); break;
  }

  //if (output.isNotEmpty) print(output[0].fileName);
  //print('${results['results'][0]}');
  return output;
}

Future<Map<String, dynamic>> getSearchStatus(Server server, int searchID) async {
  var response = await http.post(
    Uri.parse('${server.url}/api/v2/search/status'),
    headers: {'Cookie': server.cookie!},
    body: {'id': '$searchID'}
  );

  dynamic results = jsonDecode(response.body);

  return results[0];
}

/*Future<bool> isSearchRunning(Server server, int searchID) async {
  Map<String, dynamic> searchStatus = await getSearchStatus(server, searchID);

  if (searchStatus['status'] == 'Stopped') return false;

  bool output = true;

  return output;
}*/