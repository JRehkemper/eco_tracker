import 'dart:convert';
import 'dart:math';
import 'package:bike_app/resetpassword.dart';

import 'main.dart';
import 'home.dart';
import 'registration.dart';
import 'functions.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypt/crypt.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();

}

class _LoginScreen extends State {
  Functions functions = new Functions();

  final usernameCon = TextEditingController();
  final passwordCon = TextEditingController();

  var loginFailed = false;
  var emailActivation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login or Register"),
        ),
        body: Stack(children: [
          Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Images/LoginBackground.png"), fit: BoxFit.fitWidth, alignment: FractionalOffset.topCenter)),
            width: MediaQuery.of(context).size.width,),
          SingleChildScrollView(child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Center(
              child: Column(
                children: [
                  Container(padding: EdgeInsets.all(15), margin: EdgeInsets.only(top: 140),
                    child: Text("Login", style: TextStyle(fontSize: 25),),),
                  Padding(padding: EdgeInsets.only(top: 15, left: 35, bottom: 15, right: 35),
                    child: TextField(decoration: InputDecoration(border: UnderlineInputBorder(), hintText: "Enter Email or Username",), controller: usernameCon,),),
                  Padding(padding: EdgeInsets.only(top: 15, left: 35, bottom: 15, right: 35),
                    child: TextField(decoration: InputDecoration(border: UnderlineInputBorder(), hintText: "Enter Password"), controller: passwordCon, obscureText: true, ),),
                  Padding(padding: EdgeInsets.all(0),
                      child: Text(loginFailed? "Wrong Username or Password." : "")),
                  Padding(padding: EdgeInsets.all(0),
                      child: Text(emailActivation? "Please Confirm your Email first." : "")),
                  Padding(padding: EdgeInsets.all(0),
                    child: TextButton(child: Text("Forgot my password",style: TextStyle(color: Colors.black)), onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ResetPasswordScreen()));},),),
                  Padding(padding: EdgeInsets.all(0),
                      child: ElevatedButton(onPressed: () => loginProcedure(usernameCon.text, passwordCon.text, context), child: Text("Login",))),
                  //Spacer(),
                  Padding(padding: EdgeInsets.only(top: 50),
                      child: Text("You are new here? Create an Account.")),
                  Padding(padding: EdgeInsets.all(10),
                    child: ElevatedButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RegistrationScreen())), child: Text("Registration"),),),
                  //Spacer(),
                ],
              ),)
          ),),
        ],),
  );
  }
  void loginProcedure(String username, String password, BuildContext context) async {

    setState(() {
      loginFailed = false;
      emailActivation = false;
    });
    var response = await functions.getPasswordSalt(username);
    if(response.statusCode != 200) {setState(() { loginFailed = true; });return;}
    Map<String, dynamic> salt = json.decode(response.body);

    //password = Crypt.sha256(password, rounds: 5000, salt: salt["salt"]).toString();
    //print("password $password");
    response = await functions.getLoginRequest(username, password);
    if(response.statusCode != 200) {setState(() {loginFailed = true; }); return;}
    Map<String, dynamic> jwt = json.decode(response.body);

    //Check if Email is confirmed
    response = await functions.getActivationTest(username);
    var resp = json.decode(response.body);
    storage.write(key: "email", value: resp["email"]);
    if(response.statusCode != 200 || resp['status'] == 0) { setState(() { emailActivation = true; }); return;}

    print("storage write");
    storage.write(key: "access_token", value: jwt["access_token"]);
    storage.write(key: "refresh_token", value: jwt["refresh_token"]);
    storage.write(key: "salt", value: salt['salt']);
    storage.write(key: "username", value: jwt["username"]);
    storage.write(key: "email", value: jwt["email"]);
    storage.write(key: "teamID", value: jwt["teamID"].toString());

    //Test JWT Tokens
    var access_token = await storage.read(key: "access_token");
    var refresh_token = await storage.read(key: "refresh_token");
    response = await functions.getAuthTest(access_token!, refresh_token!);
    if(response.statusCode != 200) { setState(() { loginFailed = true; }); return;}
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }

}

class EmailActivationScreen extends StatefulWidget {
  @override
  _EmailActivationScreen createState() => _EmailActivationScreen();
}

class _EmailActivationScreen extends State {
  Functions functions = new Functions();

  final activationSnackbar = SnackBar(content: Text("You have to activate your Account with the link in your EMail (Check your Spam)."));

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("You have to Activate your Email"),),
      body: SingleChildScrollView(child: ConstrainedBox(
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
    child: Stack(children: [
        Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Images/LoginBackground.png"), fit: BoxFit.fitWidth, alignment: FractionalOffset.topCenter)),
                 width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,),
        Center(child: Padding(padding: EdgeInsets.all(20),child: Column(children: [
          Spacer(),
          Text("We have sent you an Email with an activation Link.\n"),
          Text("Please check your EMail Inbox (also the spam).\n"),
          Text("You need to activate your account before you can login.\n", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18), textAlign: TextAlign.center,),
          ElevatedButton(onPressed: () { continueLogin(); }, child: Text("Activation complete")),
          Spacer(),
        ]),
        ),
      )
    ]),),),);
  }

  void continueLogin() async {
    var username = await storage.read(key: "reg_username");
    var email = await storage.read(key: "reg_email");
    var password = tmp_user_password;
    var salt = await storage.read(key: "reg_salt");

    //Check if Email is confirmed
    var response = await functions.getActivationTest(email!);
    var resp = json.decode(response.body);
    print(resp);
    if (response.statusCode != 200 || resp['status'] == 0) {
      ScaffoldMessenger.of(context).showSnackBar(activationSnackbar);
      return;
    }
    storage.write(key: "email", value: resp["email"]);

    //Get JWT Tokens
    print(username);
    print(password);
    response = await functions.getLoginRequest(username!, password);
    print(response);
    if (response.statusCode != 200) {
      loginFailed();
      return;
    }
    resp = json.decode(response.body);

    //Save login
    print("Save to Storage");
    print(resp["access_token"]);
    print(resp["refresh_token"]);
    storage.write(key: "access_token", value: resp["access_token"]);
    storage.write(key: "refresh_token", value: resp["refresh_token"]);
    storage.write(key: "salt", value: salt);
    storage.write(key: "username", value: username);
    storage.write(key: "password", value: password);
    print(resp['teamID']);
    storage.write(key: "teamID", value: resp["teamID"].toString());

    //Test JWT Tokens
    var access_token = await storage.read(key: "access_token");
    var refresh_token = await storage.read(key: "refresh_token");
    response = await functions.getAuthTest(access_token!, refresh_token!);
    if (response.statusCode != 200) {
      loginFailed();
      return;
    }

    //Go to HomeScreen
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }

  void loginFailed() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
}

