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
var gradientstart = Color(0xff4caf50);
var gradientend = Color(0xff276c2b);
var fontcolor = Color(0xffffffff);
var fontweight = FontWeight.w800;
var fontshadow = [Shadow(offset: Offset(0.0,0.0),blurRadius: 7.0, color: Color(0xff444444))];
var fonthint = TextStyle(
  color: fontcolor,
  fontWeight: fontweight,
  shadows: fontshadow,
);

var roundButtonStyle = ElevatedButton.styleFrom(
    shape: new RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    )
);

var roundButtonStyleAlt = ElevatedButton.styleFrom(
  primary: Color(0xffffffff),
  onPrimary: Colors.black,
    shape: new RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
);

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
        backgroundColor: Color(0xff4CAF50),
        //scaffoldBackgroundColor: Color(0xff4CAF50),
        textTheme: TextTheme(
            bodyText1: TextStyle(
                color: fontcolor,
                fontWeight: fontweight,
                shadows: fontshadow,
            ),
            bodyText2: TextStyle(
                color: fontcolor,
                fontWeight: fontweight,
                shadows: fontshadow,
            ),
            caption: TextStyle(
                color: fontcolor,
                fontWeight: fontweight,
                shadows: fontshadow,
            ),
            subtitle1: TextStyle(
                color: fontcolor,
                fontWeight: fontweight,
                shadows: fontshadow,
            ),
            subtitle2: TextStyle(
                color: fontcolor,
                fontWeight: fontweight,
                shadows: fontshadow,
            ),
            button: TextStyle(
              color: fontcolor,
              fontWeight: fontweight,
              shadows: fontshadow,
            ),
            overline: TextStyle(
              color: fontcolor,
              fontWeight: fontweight,
              shadows: fontshadow,
            ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,//Color(0xff4CAF50),
          elevation: 0,
        )
      ),
      home: SplashScreen(),
    );
  }
}
