import 'dart:convert';
import 'dart:math';
import 'package:bike_app/login.dart';

import 'main.dart';
import 'home.dart';
import 'registration.dart';
import 'functions.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypt/crypt.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreen createState() => _ResetPasswordScreen();

}

class _ResetPasswordScreen extends State {
  Functions functions = new Functions();

  final usernameCon = TextEditingController();

  var resetDone = false;
  var error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Reset your Password"),
        ),
        body: SingleChildScrollView(child: Stack(children: [
          Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Images/LoginBackground.png"), fit: BoxFit.fitWidth, alignment: FractionalOffset.topCenter)),
            width: MediaQuery.of(context).size.width,),
          Center(
              child: Column(
                children: [
                  Container(padding: EdgeInsets.all(15), margin: EdgeInsets.only(top: 140),
                    child: Text("Enter your Email Address", style: TextStyle(fontSize: 25,), textAlign: TextAlign.center,),),
                  Padding(padding: EdgeInsets.only(top: 15, left: 35, bottom: 15, right: 35),
                    child: TextField(decoration: InputDecoration(border: UnderlineInputBorder(), hintText: "Enter Email",), controller: usernameCon,),),
                  Padding(padding: EdgeInsets.all(0),
                      child: Text(resetDone? "We have sent you an Email with a Link to reset your password." : "")),
                  Padding(padding: EdgeInsets.all(0),
                      child: Text(error? "Something went wrong. Please try again later." : "")),
                  Padding(padding: EdgeInsets.all(0),
                      child: resetDone?
                        ElevatedButton(onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));}, child: Text("Got to Login")):
                        ElevatedButton(onPressed: () {forgotPassword(usernameCon.text);}, child: Text("Send"))
                      ),
                ],
              )
          ),
        ],),)
    );
  }


  Future forgotPassword(email) async {
    print(email);
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email))
      {
        print("Wrong regex");
        return;
      }
    var map = new Map<String, dynamic>();
    map['email'] = email;
    final response = await http.post(Uri.parse(server+"/token/reqeustpasswordreset"), body: map);
    if (response.statusCode == 200)
      {
        setState(() {
          resetDone = true;
        });
      }
    else
      {
        setState(() {
          error = true;
        });
      }
  }

}