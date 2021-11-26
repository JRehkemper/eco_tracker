import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypt/crypt.dart';

import 'home.dart';
import 'functions.dart';
import 'main.dart';
import 'login.dart';



class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreen createState() => _RegistrationScreen();

}

class _RegistrationScreen extends State {
  Functions functions = new Functions();

  final emailCon = TextEditingController();
  final userCon = TextEditingController();
  final pass1Con = TextEditingController();
  final pass2Con = TextEditingController();

  var passwordCheck = false;
  var emailCheck = false;
  var emailTaken = false;
  var usertaken = false;
  var registrationFailed = false;
  var emailActivation = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
        colors: [
        gradientstart,
        gradientend,
        ],
        //stops: [0.0,1.0],
        //tileMode: TileMode.clamp,
    )
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(/*title: Text("Registration"),*/),
      body: SingleChildScrollView(child: Center(child: Column(children: [
        Padding(padding: EdgeInsets.all(15),
          child: Text("Register your Account")),
        Padding(padding: EdgeInsets.all(10),
          child: TextField(decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter Email", hintStyle: fonthint), controller: emailCon,)),
        Padding(padding: EdgeInsets.only(bottom: 0),
          child: Text(emailTaken? "Email already taken" : ""),),
        Padding(padding: EdgeInsets.all(10),
          child: TextField(decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter Displayname (visible to other Users)", hintStyle: fonthint), controller: userCon,)),
        Padding(padding: EdgeInsets.all(10),
          child: TextField(decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter Password", hintStyle: fonthint), controller: pass1Con, obscureText: true,)),
        Padding(padding: EdgeInsets.only(bottom: 0),
          child: Text(usertaken? "Username already taken" : ""),),
        Padding(padding: EdgeInsets.all(10),
          child: TextField(decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Confirm Password", hintStyle: fonthint), controller: pass2Con, obscureText: true,)),
        Padding(padding: EdgeInsets.only(bottom: 20),
          child: Text(passwordCheck? "Passwords do not match" : ""),),
        ElevatedButton(onPressed: () => registrationProcedure(emailCon.text, userCon.text, pass1Con.text, pass2Con.text, context), child: Text("Continue")),
        Padding(padding: EdgeInsets.only(top: 20),
          child: Text("Already have an Account?"),),
        ElevatedButton(onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));}, child: Text("Go to Login"))

      ],),
      )
    ),)
    );
  }

  void registrationProcedure(String email, String username, String password1, String password2, BuildContext context) async {
    // Client Side Input Validation
    setState(() {
      passwordCheck = false;
      emailCheck = false;
      emailTaken = false;
      usertaken = false;
      registrationFailed = false;
      emailActivation = false;
    });
    if(password1 != password2)
      {
        print("Password wrong");
        setState(() {
          passwordCheck = true;
        });
        return;
      }
    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email))
      {
        setState(() {
          emailCheck = true;
        });
        return;
      }
    //Check if Username is taken (204 = already Taken, 200 = all good)
    var response = await functions.postUsernameCheck(username);
    if(response.statusCode != 200) { setState(() { usertaken = true; }); return; };
    Map<String, dynamic> resp = json.decode(response.body);

    //Check if Email is taken (204 = already Taken, 200 = all good)
    response = await functions.postEmailCheck(email);
    if(response.statusCode != 200) { setState(() { emailTaken = true; }); return; }
    resp = json.decode(response.body);
    print(resp);

    //Hashing Password
    var salt = functions.generateRandomString(16);
    //var password = Crypt.sha256(password1,rounds: 5000, salt: salt).toString();

    //Register User at Server
    response = await functions.postRegister(email, username, password1, salt);
    if(response.statusCode != 200) { setState(() { registrationFailed = true; }); return;}

    storage.write(key: "reg_username", value: username);
    storage.write(key: "reg_email", value: email);
    storage.write(key: "reg_salt", value: salt);
    storage.write(key: "teamID", value: "0");
    //tmp_user_password = password1;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EmailActivationScreen()));
  }

}