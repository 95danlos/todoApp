import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'services/auth_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final AuthService auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(auth: auth),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(auth: auth),
        '/login': (BuildContext context) => new LoginPage(auth: auth)
    },
    );
  }
}