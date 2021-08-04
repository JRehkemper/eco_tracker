import 'package:bike_app/functions.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class CreateTeamScreen extends StatefulWidget {
  _CreateTeamScreen createState() => _CreateTeamScreen();
}

class _CreateTeamScreen extends State {
  Functions functions = Functions();
  var teamnameCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Create a new Team")),
      body: Center(child: Column(children: [
        Padding(padding: EdgeInsets.all(15),
          child: Text("You are about to create your own Team. In a Team you can work together to earn more Points and climb the leaderboard.",),),
        Padding(padding: EdgeInsets.all(15),
          child: Text("If you create a new Team you will leave your old one."),),
        Padding(padding: EdgeInsets.all(15),
          child: TextField(decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter Teamname",), controller: teamnameCon,),),
        Padding(padding: EdgeInsets.all(15),
          child: ElevatedButton(onPressed: () {createTeam();}, child: Text("Create"),),)
    ],)));
  }

  Future createTeam() async {
    print("create Team");
    var response = await functions.createNewTeam(teamnameCon.text);
    print(response.statusCode);
    if(response.statusCode != 200)
      {
        failDialog(context, "Creation failed", "Something went wrong. Please try again");
        return;
      }
    createDialog(context, "Your Team was created", "Your Team was successfuly created. You will return to the HomeScreen.");
  }

  void failDialog(BuildContext context, String title, String text) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(text),
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

  void createDialog(BuildContext context, String title, String text) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(text),
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