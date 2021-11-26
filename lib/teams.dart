import 'dart:convert';

import 'package:bike_app/create_team.dart';
import 'package:bike_app/functions.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class TeamsScreen extends StatefulWidget {
  _TeamsScreen createState() => _TeamsScreen();
}

class _TeamsScreen extends State {
  Functions functions = Functions();

  var teamslist;
  late Future teamslistFuture;
  var score;
  final changeError = SnackBar(content: Text("There was an error while changing your Team"));
  final changeSuccess = SnackBar(content: Text("Change successful"));

  @override
  void initState() {
    super.initState();
    teamslistFuture = createTeamsList();
    var userID = functions.readUserIDFromStorage();
    functions.getYourScore(userID).then((response) {
      if (response.statusCode != 200) {
        return;
      }
      var resp = json.decode(response.body);
      setState(() {
        score = resp['total Distance'];
      });
      print("Score updated");
    });
  }

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
      appBar: AppBar(
          /*title: Text("Teams")*/),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text("Leaderboard of Teams", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),),),
            ListTile(
                title: Text("Teamname", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),),
                trailing: Text("Distance in Km", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),)),
            FutureBuilder(future: teamslistFuture, builder: (context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(shrinkWrap:true, itemCount: teamslist.length, itemBuilder: (BuildContext context, int index)
                {
                  return InkWell(onTap: (){changeTeam(teamslist[index][0]);}, child: ListTile(
                    leading: Text("${index + 1}.", style: TextStyle(color: Colors.white),),
                    title: Text("${teamslist[index][1]}", style: TextStyle(color: Colors.white)),
                    trailing: Text("${teamslist[index][2]}", style: TextStyle(color: Colors.white)),
                  )
                );});
              }
            }),
            Spacer(),
            Padding(padding: EdgeInsets.symmetric(vertical: 15), child: FloatingActionButton(onPressed: () {createNewTeam();}, child: Icon(Icons.add, color: Colors.black), backgroundColor: Colors.white,)),
      ],),),),);
  }

  Future<List> createTeamsList() async {
    var response = await functions.getTeamsList();
    var resp = json.decode(response.body);
    setState(() {
      teamslist = resp;
    });
    return resp;
  }

  Future createNewTeam() async {
    if(score < 00)
      {
        showAlertDialog(context, "Your Score is too low. You need to have at least 100km to create a new Team.");
        return;
      }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CreateTeamScreen()));
  }

  Future changeTeam(id) async {
    var response = await functions.changeTeam(id.toString());
    if(response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(changeError);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(changeSuccess);
  }

  void showAlertDialog(BuildContext context, String response) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Your Score is to low"),
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