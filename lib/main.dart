import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:messenger_personal/main.dart';
import 'package:http/http.dart' as http;

const String host = '10.0.2.2';

Future<ServerResponseRegister> register(username, password) async{
  final response = await http.post(Uri.parse('http://$host:8000/register'),
  body: <String, dynamic>{
    'username': username,
    'password': password
  }
  );

  if (response.statusCode == 200) {
    return ServerResponseRegister.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('Request failed');
  }
}

Future<ServerResponseLogin> login(username, password) async{
  final response = await http.post(Uri.parse('http://$host:8000/login'),
  body: <String, dynamic>{
    'username': username,
    'password': password
  });

  if (response.statusCode == 200) {
    return ServerResponseLogin.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('Request failed');
  }
}

class ServerResponseRegister {
  final dynamic id;
  final dynamic username;
  final dynamic password;
  final dynamic message;

  const ServerResponseRegister({this.id, this.username, this.password, this.message
});

  factory ServerResponseRegister.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      return ServerResponseRegister(
        message: json['message']
      );
    }
    else {
      return ServerResponseRegister(
        id: json['id'],
        username: json['username'],
        password: json['password'],
      );
    }
  }
}

class ServerResponseLogin {
  final dynamic token;

  const ServerResponseLogin({
    required this.token,
});

  factory ServerResponseLogin.fromJson(Map<String, dynamic> json) {
    return ServerResponseLogin(
      token: json['token']
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text(
                  'Register'
                ),
              onPressed: (){
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()
                    ));
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()
                    ));
                },
                child: const Text(
                  'Login'
                )
              )
            ]
          ),
        )
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final passwordFieldController = TextEditingController();
  final usernameFieldController = TextEditingController();
  String username = "";
  String password = "";
  Future<ServerResponseRegister>? _futureRegister;

  @override
  void initState() {
    super.initState();

    passwordFieldController.addListener(() {
      password = passwordFieldController.text;
      print(password);
    });
    usernameFieldController.addListener(() {
      username = usernameFieldController.text;
      print(username);
    });
  }

  @override
  void dispose() {
    passwordFieldController.dispose();
    usernameFieldController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    <Widget>[
                      TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'username',
                        ),
                        onSubmitted: (text) {
                          username = text;
                        },
                        controller: usernameFieldController,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'password'
                        ),
                        onSubmitted: (text) {
                          password = text;
                        },
                        controller: passwordFieldController,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            dynamic resp = await register(username, password);
                            print(resp.id);
                            print(resp.username);
                            print(resp.password);
                            if (!context.mounted) return;
                            late var snackBar;
                            if (resp.id == null) {
                              snackBar = SnackBar(
                                content: Text(
                                  'message: ${resp.message}\n'
                                )
                              );
                            }
                            else {
                              snackBar = SnackBar(
                                content: Text(
                                    'id: ${resp.id},\n'
                                    'username: ${resp.username},\n'
                                    'password: ${resp.password}\n'
                                )
                              );
                            }
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            Navigator.pop(context);
                          },
                          child: const Text(
                              'Submit'
                          )
                      ),
                    ]
                )
            )
        )
    );
  }


  FutureBuilder<ServerResponseRegister> buildFutureBuilder() {
    return FutureBuilder(
        future: _futureRegister,
        builder: (context, snapshot) => AlertDialog(
          title: const Text('Register response'),
          content: Text(snapshot.data.toString()),
          )
      );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final passwordFieldController = TextEditingController();
  final usernameFieldController = TextEditingController();
  String username = "";
  String password = "";

  @override
  void initState() {
    super.initState();

    passwordFieldController.addListener(() {
      password = passwordFieldController.text;
      print(password);
    });
    usernameFieldController.addListener(() {
      username = usernameFieldController.text;
      print(username);
    });
  }

  @override
  void dispose() {
    passwordFieldController.dispose();
    usernameFieldController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    <Widget>[
                      TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'username',
                        ),
                        onSubmitted: (text) {
                          username = text;
                        },
                        controller: usernameFieldController,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'password'
                        ),
                        onSubmitted: (text) {
                          password = text;
                        },
                        controller: passwordFieldController,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            print(login(username, password));
                            Navigator.pop(context);
                          },
                          child: const Text(
                              'Enter'
                          )
                      )
                    ]
                )
            )
        )
    );
  }


}