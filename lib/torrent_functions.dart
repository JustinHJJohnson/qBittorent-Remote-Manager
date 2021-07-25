import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'utility_functions.dart';

/// Login to the qBittorrent server on the URL from [baseURL] and return the cookie used for further api calls.
Future<String> login(String baseURL, String username, String password, BuildContext context) async {
  // get auth cookie by logging in
  var url = Uri.parse('$baseURL/api/v2/auth/login');
  print('request URL is $baseURL/api/v2/auth/login');
  dynamic response;
  try {
    print('baseURL is $baseURL');
    print('username and pass is username=$username&password=$password');
    response = await http.post(
      url,
      headers: {'Referer': baseURL},
      body: {'username' : username, 'password': password}
    );
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

/// Get all the details on all the current torrents at [baseURL] with [cookie]
Future<List<Map<String, dynamic>>> getTorrents(String baseURL, String cookie) async {
  // Get info on all current torrents
  var url2 = Uri.parse('$baseURL/api/v2/torrents/info');
  var response2 = await http.post(url2, headers: {'Cookie': 'SID=$cookie'});
  print('Response 2 status: ${response2.statusCode}');
  print('Response 2 body: ${response2.body}');

  // Split to JSON data into seperate torrents and decode them
  RegExp torrentPattern = RegExp(r'({.+?}).');
  Iterable<RegExpMatch> torrentMatches = torrentPattern.allMatches(response2.body);
  List<Map<String, dynamic>> torrents = [];
  for (var torrent in torrentMatches) torrents.add(jsonDecode(torrent.group(1)!));
    
  print('Number of torrents is ${torrents.length}');

  return torrents;
}

/// Logout from the session with [cookie] at [baseURL]
Future<void> logout(String baseURL, String cookie) async {
  await http.post(
    Uri.parse('$baseURL/api/v2/auth/logout'),
    headers: {'Cookie': 'SID=$cookie'}
  );
}