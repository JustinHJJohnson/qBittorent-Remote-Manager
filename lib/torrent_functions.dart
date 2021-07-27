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
  var response2 = await http.post(url2, headers: {'Cookie': server.cookie!});
  //print('Get Torrent Response status: ${response2.statusCode}');
  //print('Get Torrent Response body: ${response2.body}');     

  List<Torrent> torrents = [];

  // Decode the torrents and convert them to torrent objects
  dynamic torrentsJson = jsonDecode(response2.body);
  for (var torrent in torrentsJson) torrents.add(Torrent.fromJson(torrent));
    
  //print('Number of torrents is ${torrents.length}');

  return torrents;
}