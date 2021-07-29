import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'server.dart';
import 'torrent.dart';

Future<void> showDeleteTorrentDialog(BuildContext context, Torrent torrent, Server server) async {
  return await showDialog(
    context: context,
    builder: (context) {
      bool _deleteFiles = false;

      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text("Delete Torrent?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),   // Rounded corners from https://stackoverflow.com/questions/58533442/flutter-how-to-make-my-dialog-box-scrollable
          scrollable: true,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flexible(
                  //child: Text('Are you sure you want to delete ${torrent.name}?')
                  child: Text(torrent.name)
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    value: _deleteFiles,
                    onChanged: (bool? value) {
                      setState(() {_deleteFiles = value!;});
                    },
                  ),
                  Flexible(child: Text('Delete files from harddisk')),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    var response = await http.post(
                      Uri.parse('${server.url}/api/v2/torrents/delete'),
                      headers: {'Cookie': server.cookie!},
                      body: {
                        'hashes': torrent.hash,
                        //'deleteFiles': _deleteFiles.toString().toLowerCase()
                        'deleteFiles': _deleteFiles.toString()
                      }
                    );

                    print('Delete response: ${response.body}');
                    Navigator.of(context).pop(true);
                  },
                  icon: Icon(Icons.delete),
                  label: Text("Delete")
                )
              )
            ],
          ),
        );
      });
    }
  );
}