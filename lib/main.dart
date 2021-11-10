import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login.dart';
import 'splashscreen.dart';

final storage = FlutterSecureStorage();
final server = 'https://jrehkemper.de/bikeapp';
var tmp_user_password = "";
var welcomeGuideShown = false;
var guestLogin = false;
var offline = false;
var mainUsername = "";
var mainUserID = "";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
    );
  }
}
