import 'package:bike_app/main.dart';
import 'package:bike_app/welcome_guide.dart';

import 'functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State {
  Functions functions = new Functions();
  var username;
  var access_token;
  var refresh_token;

  @override
  void initState() {
    super.initState();
    try{functions.autoLoginStart().then((response) {
      if (response != null && response.statusCode == 200)
        {
          print("success");
          //showAlertDialog(context, response.body);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
        }
      else if (response.statusCode == 502)
        {
          offline = true;
        }
      else {
        guestLogin = true;
        functions.welcomeGuidCheck().then((guide) {
          print(guide);
          if(guide == "true" && welcomeGuideShown == false)
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => WelcomeGuide()));
            }
          else if(guide == "false" || welcomeGuideShown == true)
            {
              //Guest Mod
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
            }

          else{
            if (response != null)
            {
              print("error with Response");
              showAlertDialog(context, response.body);
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
            }
            else
            {
              print("error");
              showAlertDialog(context, "The Sever is currently under maintainance. Please try again later.");
            }
          }
        });
      }
    });}
    catch (error) {
      showAlertDialog(context, "The Sever is currently under maintainance. Please try again later.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.green,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/Images/icon.png', fit: BoxFit.contain)
        ],),
      ),
    );
  }

  void showAlertDialog(BuildContext context, String response) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error while Login"),
      content: Text(response),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


}