import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'server.dart';
import 'torrent.dart';
import 'utility_functions.dart';

/// Get all the details on all the current torrents at [baseURL] with [cookie]
Future<List<Torrent>> getTorrents(Server server) async {
  // Get info on all current torrents
  var url2 = Uri.parse('${server.url!}/api/v2/torrents/info');
  var response2 = await http.post(url2, headers: {'Cookie': 'SID=${server.cookie}'});
  print('Response 2 status: ${response2.statusCode}');
  print('Response 2 body: ${response2.body}');

  // Split to JSON data into seperate torrents and decode them
  /*RegExp torrentPattern = RegExp(r'({.+?}).');
  Iterable<RegExpMatch> torrentMatches = torrentPattern.allMatches(response2.body);
  List<Map<String, dynamic>> torrents = [];
  for (var torrent in torrentMatches) torrents.add(jsonDecode(torrent.group(1)!));*/
  //List<Map<String, dynamic>> torrents = jsonDecode(response2.body);
  List<Torrent> torrents = [];

  dynamic torrentsJson = jsonDecode(response2.body);
  for (var torrent in torrentsJson) torrents.add(Torrent.fromJson(torrent));

  //print(Torrent.fromJson([0]));
    
  //print('Number of torrents is ${torrents.length}');

  return torrents;
}

/// Logout from the session with [cookie] at [baseURL]
Future<void> logout(String baseURL, String cookie) async {
  await http.post(
    Uri.parse('$baseURL/api/v2/auth/logout'),
    headers: {'Cookie': 'SID=$cookie'}
  );
}