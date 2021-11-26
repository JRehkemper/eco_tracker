import 'dart:convert';

import 'package:crypt/crypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'home.dart';
import 'main.dart';

class ChangePasswordScreen extends StatefulWidget {
  _ChangePasswordScreen createState() => _ChangePasswordScreen();
}

class _ChangePasswordScreen extends State {
  Functions functions = new Functions();

  final passwordOldCon = TextEditingController();
  final password1Con = TextEditingController();
  final password2Con = TextEditingController();

  var passwordMatch = false;
  var passwordOld = false;

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
      appBar: AppBar(title: Text("You have to Activate your Email"),),
      body: SingleChildScrollView(child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(15),
                child: Text("Change Password"),),
              Padding(padding: EdgeInsets.all(15),
                child: TextField(decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Old Password",), controller: passwordOldCon, obscureText: true,),),
              Padding(padding: EdgeInsets.all(15),
                child: TextField(decoration: InputDecoration(border: OutlineInputBorder(), hintText: "New Password"), controller: password1Con, obscureText: true, ),),
              Padding(padding: EdgeInsets.all(15),
                child: TextField(decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Confirm New Password"), controller: password2Con, obscureText: true, ),),
              Padding(padding: EdgeInsets.all(0),
                  child: Text(passwordMatch? "Passwords do not match":"")),
              Padding(padding: EdgeInsets.all(0),
                  child: Text(passwordOld? "Old Password is not correct":"")),
              Padding(padding: EdgeInsets.all(0),
                  child: ElevatedButton(onPressed: () {checkPassword();}, child: Text("Continue"),)),
            ],
          )
      ),),
    )
    );
  }

  void checkPassword() async {
    setState(() {
      passwordMatch = false;
      passwordOld = false;
    });
    if(password1Con.text != password2Con.text)
      {
        setState(() {
          passwordMatch = true;
        });
        return;
      }
    var salt = await functions.readSaltFromStorage();
    //var oldPassword = Crypt.sha256(passwordOldCon.text, salt: salt).toString();
    var oldPassword = passwordOldCon.text;
    var response = await functions.checkPassword(oldPassword);
    if(response.statusCode != 200)
    {
      setState(() {
        passwordOld = true;
      });
      return;
    }
    var resp = json.decode(response.body);
    //var password = Crypt.sha256(password1Con.text, salt: salt).toString();
    var password = password1Con.text;
    response = await functions.changePassword(password);
    if(response.statusCode != 200)
      {
        return;
      }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
  }

}