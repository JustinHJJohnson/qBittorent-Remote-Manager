import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qbittorrent_remote_manager/searchResult.dart';
import 'package:qbittorrent_remote_manager/server.dart';
import 'package:http/http.dart' as http;

import 'utility_functions.dart';
import 'torrent_functions.dart';

class SearchScreen extends StatefulWidget {
  final Server server;
  SearchScreen(this.server);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _search = new TextEditingController();
  final TextEditingController _filter = new TextEditingController();

  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text('Search');
  Timer? _timer;
  int _iteration = 0;
  int _lastTotal = 0;

  List<SearchResult> _searchResults = [];
  List<SearchResult> _searchResultsFiltered = [];

  int _searchID = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: [
          IconButton(
            icon: _searchIcon,
            tooltip: '',
            onPressed: () {
              setState(() {
                if (this._searchIcon.icon == Icons.search) {
                  this._searchIcon = new Icon(Icons.close);
                  this._appBarTitle = new TextField(
                    controller: _search,
                    decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search),
                      hintText: 'Search...'
                    ),
                    onEditingComplete: () async {
                      print("Done editting");

                      // This block close the keyboard when the user presses enter/return
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      int searchID = await startSearch(widget.server, _search.text);
                      //List<SearchResult> tempSearchResults = await getSearchResults(widget.server, searchID);
                      setState(() {
                        _searchID = searchID;
                        //_searchResults = tempSearchResults;
                        //_searchResultsFiltered = _searchResults;
                        _searchResults = [];
                        _searchResultsFiltered = [];
                      });

                      // A timer to get the new search results until the search status changes or we find no extra results after 20 iterations
                      _timer = new Timer.periodic(Duration(seconds: 1), (timer) async {
                        bool searchRunning = true;
                        Map<String, dynamic> searchStatus = await getSearchStatus(widget.server, _searchID);

                        print("Current iteration is $_iteration\nCurrent total is ${searchStatus['total']}");
                        print("Search status: $searchStatus");
                        
                        if (searchStatus['status'] == 'Stopped' || _iteration >= 20) {
                          searchRunning = false;

                          setState(() {
                            _iteration = 0;
                            _lastTotal = 0;
                          });

                          searchRunning = false;
                          var response = await http.post(
                            Uri.parse('${widget.server.url}/api/v2/search/stop'),
                            headers: {'Cookie': widget.server.cookie!},
                            body: {'id': '$_searchID'}
                          );

                          print('status code from stopping search: ${response.statusCode}');

                          var response2 = await http.post(
                            Uri.parse('${widget.server.url}/api/v2/search/delete'),
                            headers: {'Cookie': widget.server.cookie!},
                            body: {'id': '$_searchID'}
                          );

                          print('status code from deleting search: ${response2.statusCode}');
                        }
                        
                        setState(() {
                          searchStatus['total'] == _lastTotal ? _iteration++ : _iteration = 0;
                        });

                        if (searchRunning) {
                          print('Search is running');
                          List<SearchResult> temp = await getSearchResults(widget.server, searchID);
                          setState(() {
                            _searchResults = temp;
                            _searchResultsFiltered = _searchResults;
                          });
                        }
                        else {
                          print('Search is done');
                          _timer!.cancel();
                        }

                        setState(() {_lastTotal = searchStatus['total'];});
                      });
                    },
                  );
                } else {
                  this._searchIcon = new Icon(Icons.search);
                  this._appBarTitle = new Text('Search');
                  //filteredNames = names;
                  _filter.clear();
                }
              }); 
            },
          ),
        ]
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResultsFiltered.length,
                  itemBuilder: (BuildContext context, int index) {
                    var searchResult = _searchResultsFiltered[index];

                    return ListTile(
                      title: Text(searchResult.fileName),
                      tileColor: index % 2 == 0 ? Colors.white : Color.fromRGBO(220, 220, 220, 0.1),
                      subtitle: Text(
                        'Size: ${formatSize(searchResult.fileSize)}\n'
                        'Seeders: ${searchResult.numSeeders}\n'
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async {
          List<SearchResult> results = await getSearchResults(widget.server, _searchID);
          setState(() {
            _searchResults = results;
            _searchResultsFiltered = results;
          });
        }
      ),
    );
  }
}