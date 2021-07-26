import 'package:flutter/material.dart';

import 'server.dart';
import 'torrent_functions.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ipController = TextEditingController();
  final portController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    nameController.text = "NAS Box 3.0";
    ipController.text = "192.168.0.91";
    portController.text = "8080";
    usernameController.text = "admin";
    passwordController.text = "Qywter101";

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(hintText: "Name"),
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name for the server';
                        }
                        return null;
                      },                          
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(hintText: "IP"),
                              controller: ipController,
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
                          child: TextFormField(
                            decoration: InputDecoration(hintText: "Port"),
                            controller: portController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a port';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "Username"),
                      controller: usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },                          
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "Password"),
                      controller: passwordController,
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
                          if (formKey.currentState!.validate())
                          {
                            final String baseURL = 'http://${ipController.text}:${portController.text}';

                            Server server = Server(
                              nameController.text,
                              baseURL,
                              usernameController.text,
                              passwordController.text,
                              null,
                              false
                            );
                            
                            await server.login(context);

                            if (server.connected) Navigator.pop(context, server);
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