import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'utility_functions.dart';

/// Store all the information related to a server
class Server {
  /// Name of the server, is nullable
  String? name;
  /// URL of the server, is nullable
  String? url;
  /// Username for authentication on the server, is nullable
  String? username;
  /// Password for authentication on the server, is nullable
  String? password;
  /// Cookie used to track session with the server, is nullable
  String? cookie;
  /// If the connection to the server was successful
  bool connected;

  Server(
    this.name,
    this.url,
    this.username,
    this.password,
    this.cookie,
    this.connected
  );

  Server.failedConnection():
    this.connected = false;

    /// Login to the qBittorrent server on the URL from [baseURL] and return the cookie used for further api calls.
  //Future<Server> login(String baseURL, String username, String password, BuildContext context) async {
  Future<void> login(BuildContext context) async {
    // get auth cookie by logging in
    var url = Uri.parse('${this.url!}/api/v2/auth/login');
    print('request URL is ${this.url!}/api/v2/auth/login');
    dynamic response;
    try {
      //print('baseURL is $server.url');
      print('username and pass is username=${this.username!}&password=${this.password!}');
      response = await http.post(
        url,
        headers: {'Referer': this.url!},
        body: {'username' : this.username!, 'password': this.password!}
      );
    } on SocketException catch (_) {
      showCustomSnackBar(context, 'Failed to login');
      this.connected = false;
      return;
    }
    if (response.body == "Fails.") {
      print('Failed to login with code ${response.statusCode}');
      print('body: ${response.body}');
      showCustomSnackBar(context, 'Invalid login details');
      this.connected = false;
      return;
    }
    else if (response.statusCode == 403) {
      print('Failed to login due to too many repeated login attempts');
      showCustomSnackBar(context, 'Failed to login due to too many repeated login attempts');
      this.connected = false;
      return;
    }
    else if (response.statusCode == 400) {
      print('Failed with a code of 400');
      showCustomSnackBar(context, 'Failed with a code of 400');
      this.connected = false;
      return;
    }

    showCustomSnackBar(context, 'Login successful');
    print('Response 1 status: ${response.statusCode}');
    print('Response 1 body: ${response.body}');
    print('Response 1 headers: ${response.headers}');


    // Extract the cookie from the response header for auth in future requests
    var rawCookieHeader = response.headers["set-cookie"]!;
    RegExp pattern = RegExp(r'SID=\S+;');
    final cookieMatch = pattern.firstMatch(rawCookieHeader)!;
    final cookie = cookieMatch;
    print('cookie response is ${response.headers["set-cookie"]!}');
    print("Cookie is $cookie");

    this.cookie = cookie.toString();
    this.connected = true;

    return;
  }

  /// Logout from the session with [cookie] at [baseURL]
  Future<void> logout() async {
    if (this.connected) {
      var response = await http.post(
        Uri.parse('${this.url}/api/v2/auth/logout'),
        headers: {'Cookie': 'SID=${this.cookie}'}
      );

      print(response.body);
    }
  }
}