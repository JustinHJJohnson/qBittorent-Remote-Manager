/// This class handles logging in and creating a server object to pass back to
/// the main widget
import 'package:flutter/material.dart';

import 'server.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    _nameController.text = "NAS Box 3.0";
    _ipController.text = "192.168.0.91";
    _portController.text = "8080";
    _usernameController.text = "admin";
    _passwordController.text = "Qywter101";

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
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(hintText: "Name"),
                      controller: _nameController,
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
                              controller: _ipController,
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
                            controller: _portController,
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
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },                          
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 10,
                          child: TextFormField(
                            decoration: InputDecoration(hintText: "Password"),
                            controller: _passwordController,
                            obscureText: _hidePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            }
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: IconButton(
                            onPressed: () => setState(() {_hidePassword = !_hidePassword;}), 
                            icon: Icon(Icons.remove_red_eye_outlined)
                          )
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate())
                          {
                            final String baseURL = 'http://${_ipController.text}:${_portController.text}';

                            Server server = Server(
                              _nameController.text,
                              baseURL,
                              _usernameController.text,
                              _passwordController.text,
                              null,
                              false
                            );
                            
                            await server.login(context);

                            if (server.connected) Navigator.pop(context, server);
                          }
                        },
                        icon: Icon(Icons.login),
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