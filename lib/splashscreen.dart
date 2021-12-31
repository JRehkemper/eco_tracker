import 'dart:convert';

import 'package:bike_app/main.dart';
import 'package:bike_app/welcome_guide.dart';

import 'functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
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
  var userIDdone;

  @override
  void initState() {
    super.initState();
    try{functions.autoLoginStart().then((response) async {
      if (response != null && response.statusCode == 200)
        {
          print("success");
          //showAlertDialog(context, response.body);
          await functions.readUserIDFromStorage().then((String result) async {
            //setState(() {
            if(result != "0") {
              mainUserID = result;
              if (mainUserID == "" || mainUserID == null) {
                await functions.readUsernameFromStorage().then((result) async {
                  //setState(() {
                  username = result;
                  //});
                  await functions.getUserID(username).then((result) {
                    //print("Get User ID");
                    //setState(() {
                    var resp = json.decode(result.body);
                    //print(resp['userID']);
                    mainUserID = resp['userID'].toString();
                    userIDdone = true;
                    //});
                  });
                });
              };
              print("Main User ID in Splash " + mainUserID);
              //});
            }
          });

          await userIDdone;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
        }
      else if (response.statusCode == 502)
        {
          offline = true;
          showAlertDialog(context, "The Sever is currently unreachable. Check your Internet connection or try again later.");
          print("Server offline");
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
          Image.asset('assets/Images/org_thebus_foregroundserviceplugin_notificationicon.png', fit: BoxFit.contain)
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