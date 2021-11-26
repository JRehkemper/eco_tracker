import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'functions.dart';
import 'main.dart';
import 'home.dart';
import 'achievement.dart';

class ProfileScreen extends StatefulWidget {
  final userID;
  ProfileScreen(this.userID);

  @override
  _ProfileScreen createState() => _ProfileScreen(this.userID);
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
  var username;
  var myuser = false;
  var achievementNumber = 0;

  _ProfileScreen(this.userID);

  @override
  void initState() {
    print("UserID "+this.userID.toString());
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
        username = resp['username'].toString();
        print(username);
        responseFuture = response;
        team = true;
      });
      if(mainUsername == username) {
        myuser = true;
      }
      print("teamID "+teamID);
      print("Done initPage");

    });
    createScoreboardList();
    functions.getNumberOfAchievments(userID).then((response) {
      var resp = json.decode(response.body);
      setState(() {
        achievementNumber = resp['numberOfAchievements'];
      });
    });
    await Future.delayed(Duration(milliseconds: 300));
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
    for (int i = 0; i < scoreboard.length; i++) {
      if (scoreboard[i][2].toString() == userID.toString()) {
        setState(() {
          yourRank = i + 1;
        });
      }
    }
    print("Scoreboard done");
    return resp;
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
      appBar: AppBar(/*title: Text("Profile"),*/),
      body: FutureBuilder(
        future: pageFuture,
        builder: (context, snapshot) {
          if(snapshot.data == null) {
            return Center(child: new CircularProgressIndicator());
          }
          return SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Stack(children: [
                        Image.network(server+"/user/getProfilePicture/"+userID.toString(), width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: myuser? IconButton(
                                onPressed: ()  {
                                  getImage();
                                },
                                icon: Icon(Icons.edit)):
                            SizedBox.shrink(),
                          ),
                        ),
                      ],),),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(username, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, shadows: [Shadow(blurRadius: 20, color: Colors.black12)]),),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: GridView.count(physics: NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 10, shrinkWrap: true, padding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          homeScreenCard(text1: "Your Score:", text2: "$score km", icon: Icons.leaderboard),
                          homeScreenCard(text1: "You saved:", text2: "${co2.toStringAsFixed(3)} kg CO2", icon: Icons.score),
                          homeScreenCard(text1: "Your Rank:", text2: "#$yourRank", icon: Icons.query_builder),
                          homeScreenCard(text1: "Team ID", text2: team? "#$teamID":"No Team", icon: Icons.group),
                          InkWell(
                            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AchievementScreen(userID)));},
                            child: homeScreenCard(text1: "Achievements", text2: "$achievementNumber", fontsize: 18, icon: Icons.check_box),
                          ),
                        ]
                    ),
                  )
                  //Spacer(),
              ],)
            ),
          );
        }
      )
    ),
    );
  }
}