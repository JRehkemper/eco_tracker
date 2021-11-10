import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'functions.dart';
import 'main.dart';
import 'home.dart';

class ProfileScreen extends StatefulWidget {
  final userID;
  ProfileScreen(this.userID);

  @override
  _ProfileScreen createState() => _ProfileScreen(userID);
}

class _ProfileScreen extends State {

  Functions functions = new Functions();
  late PickedFile? _image;
  late File fileImage;
  var profileImage;
  var userID;
  var score = 0.0;
  var co2 = 0.0;
  var scoreboard;
  var yourRank = 0;
  var teamID;
  var team = false;
  var teamRank;
  late Future pageFuture;

  _ProfileScreen(this.userID);

  @override
  void initState() {
    this.pageFuture = initPage();
    super.initState();
    print("pageFuture Filled");
    /*initPage().then((result) {
      setState(() {
        pageFuture = result;
      });

    });*/

  }

  Future initPage() async {
    print("start initPage");
    var responseFuture;
    functions.getYourScore(userID).then((response) {
      if (response.statusCode != 200) {
        return;
      }
      var resp = json.decode(response.body);
      setState(() {
        score = resp['totalDistance'];
        if (score == null) {
          score = 0.0;
        }
        co2 = score * 128.1 / 1000;
      });
      print("Score updated");
    });
    functions.getTeamID(userID).then((response) {
      var resp = json.decode(response.body);
      setState(() {
        teamID = resp['TeamID'].toString();
        responseFuture = response;
        team = true;
      });
      print("teamID "+teamID);
      print("Done initPage");

    });
    await Future.delayed(Duration(seconds: 1));
    print("return");
    return responseFuture;
  }

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      fileImage = File(image!.path);
    });
    functions.uploadProfileImage(fileImage);
  }

  Future<List> createScoreboardList() async {
    var response = await functions.getScoreBoard();
    var resp = json.decode(response.body);
    setState(() {
      scoreboard = resp;
    });
    if(!guestLogin) {
      var username = await functions.readUsernameFromStorage();
      mainUsername = username;
      for (int i = 0; i < scoreboard.length; i++) {
        if (scoreboard[i][0] == username) {
          setState(() {
            yourRank = i + 1;
            userID = scoreboard[i][2];
            teamID = scoreboard[i][3];
          });
        }
      }
      storage.write(key: "userID", value: userID.toString());
    }
    response = await functions.getTeamsList();
    resp = json.decode(response.body);
    print(resp);
    for(int i = 0; i < resp.length; i++)
    {
      if(resp[i][0] == teamID)
      {
        setState(() {
          teamRank = i + 1;
          team = true;
        });
      }
    }
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),),
      body: FutureBuilder(
        future: pageFuture,
        builder: (context, snapshot) {
          if(snapshot.data == null) {
            return Center(child: new CircularProgressIndicator());
          }
          return SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
                  Stack(children: [
                    Image.network(server+"/user/getProfilePicture/67"),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                            onPressed: ()  {
                              getImage();
                            },
                            icon: Icon(Icons.edit)),
                      ),
                    ),
                  ],),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(mainUsername, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, shadows: [Shadow(blurRadius: 20, color: Colors.black12)]),),
                  ),
                  GridView.count(physics: NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 10, shrinkWrap: true, padding: EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        homeScreenCard(text1: "Your Score:", text2: "$score km"),
                        homeScreenCard(text1: "You saved:", text2: "${co2.toStringAsFixed(3)} kg CO2"),
                        homeScreenCard(text1: "Your Rank:", text2: "#$yourRank",),
                        homeScreenCard(text1: "Team ID", text2: team? "#$teamID":"No Team"),
                      ]
                  ),
                  //Spacer(),
                ],)
            ),
          );
        }
      )

      );
      /*CustomScrollView(
        slivers: [ SliverFillRemaining(
            hasScrollBody: true,
            child: Column(children: [
              Stack(children: [
                Image.network(server+"/user/getProfilePicture/67"),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: ()  {
                        getImage();
                      },
                      icon: Icon(Icons.edit)),
                  ),
                ),
              ],),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(mainUsername, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, shadows: [Shadow(blurRadius: 20, color: Colors.black12)]),),
              ),
              GridView.count(physics: NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 10, shrinkWrap: true, padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  homeScreenCard(text1: "Your Score:", text2: "$score km"),
                  homeScreenCard(text1: "You saved:", text2: "${co2.toStringAsFixed(3)} kg CO2"),
                  homeScreenCard(text1: "Your Rank:", text2: "#$yourRank",),
                  homeScreenCard(text1: "Team Rank", text2: team? "#$teamRank":"No Team"),
                ]
              ),
              Spacer(),
          ],)
        ),]
      )*/
  }

}