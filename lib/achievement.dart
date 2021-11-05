import 'dart:convert';

import 'package:bike_app/functions.dart';
import 'package:bike_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AchievementScreen extends StatefulWidget {
  _AchievementScreen createState() => _AchievementScreen();
}

class _AchievementScreen extends State {

  Functions functions = Functions();
  late Future<List> achievments_future;
  var achievments = [];
  var achievmentlist;
  /*ValueNotifier<double> vscore = ValueNotifier(0.0);
  var score = 0.0;*/

  @override
  void initState() {
    if(!guestLogin) {
      achievments_future = getYourAchievments();
      getYourAchievments().then((response) {
        var arr = [];
        int i = 0;
        while (i < response.length) {
          arr.add(response[i][0]);
          i++;
        }
        //achievments_future = response;
        achievments = arr;
        //print("achievments $achievments");
      });
      getAchievmentList().then((response) {
        achievmentlist = response;
        //print("achievmentsList $achievmentlist");
      });
    }
    else {
      achievments_future = guestFuture();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Achievements")),
        body: SafeArea(
            child: SingleChildScrollView(
              child: guestLogin?
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child:
                        Text("You are Guest", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),),
                    Text("You need to be logged in to see your Achievements.", style: TextStyle(fontSize: 20,), textAlign: TextAlign.center,)
                  ],
                ):
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child:
                        Text("Achievements", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),),
                    FutureBuilder(
                        future: achievments_future,
                        builder: (context, AsyncSnapshot snapshot) {
                          if(!snapshot.hasData) {
                            return Center(
                                child: CircularProgressIndicator());
                          } else {
                            return GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 10,
                              padding: EdgeInsets.all(10),
                              children: [
                                /*Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: (achievments.contains(1))?Colors.white : Colors.grey,
                                      boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                                  child: Column(
                                    children: [
                                      Text("${achievmentlist[0][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                                      Spacer(),
                                      Text("${achievmentlist[0][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                      Spacer(),
                                    ],
                                  ),
                                ),*/
                                achievementGridCard(name: achievmentlist[0][1], desription: achievmentlist[0][2], granted: achievments.contains(1)),
                                achievementGridCard(name: achievmentlist[1][1], desription: achievmentlist[1][2], granted: achievments.contains(2)),
                                achievementGridCard(name: achievmentlist[2][1], desription: achievmentlist[2][2], granted: achievments.contains(3)),
                                achievementGridCard(name: achievmentlist[3][1], desription: achievmentlist[3][2], granted: achievments.contains(4)),
                                achievementGridCard(name: achievmentlist[4][1], desription: achievmentlist[4][2], granted: achievments.contains(5)),
                                achievementGridCard(name: achievmentlist[5][1], desription: achievmentlist[5][2], granted: achievments.contains(6)),
                                achievementGridCard(name: achievmentlist[9][1], desription: achievmentlist[9][2], granted: achievments.contains(10)),
                                achievementGridCard(name: achievmentlist[10][1], desription: achievmentlist[10][2], granted: achievments.contains(11)),
                                achievementGridCard(name: achievmentlist[11][1], desription: achievmentlist[11][2], granted: achievments.contains(12)),
                                achievementGridCard(name: achievmentlist[12][1], desription: achievmentlist[12][2], granted: achievments.contains(13)),
                                achievementGridCard(name: achievmentlist[13][1], desription: achievmentlist[13][2], granted: achievments.contains(14)),
                                achievementGridCard(name: achievmentlist[14][1], desription: achievmentlist[14][2], granted: achievments.contains(15)),
                                achievementGridCard(name: achievmentlist[15][1], desription: achievmentlist[15][2], granted: achievments.contains(16)),
                                achievementGridCard(name: achievmentlist[19][1], desription: achievmentlist[19][2], granted: achievments.contains(20)),
                                achievementGridCard(name: achievmentlist[20][1], desription: achievmentlist[20][2], granted: achievments.contains(21)),
                                achievementGridCard(name: achievmentlist[21][1], desription: achievmentlist[21][2], granted: achievments.contains(22)),
                                achievementGridCard(name: achievmentlist[29][1], desription: achievmentlist[29][2], granted: achievments.contains(30)),
                                achievementGridCard(name: achievmentlist[30][1], desription: achievmentlist[30][2], granted: achievments.contains(31)),
                                achievementGridCard(name: achievmentlist[31][1], desription: achievmentlist[31][2], granted: achievments.contains(32)),
                                achievementGridCard(name: achievmentlist[32][1], desription: achievmentlist[32][2], granted: achievments.contains(33)),
                                achievementGridCard(name: achievmentlist[33][1], desription: achievmentlist[33][2], granted: achievments.contains(34)),
                                achievementGridCard(name: achievmentlist[39][1], desription: achievmentlist[39][2], granted: achievments.contains(40)),
                                achievementGridCard(name: achievmentlist[40][1], desription: achievmentlist[40][2], granted: achievments.contains(41)),
                                achievementGridCard(name: achievmentlist[41][1], desription: achievmentlist[41][2], granted: achievments.contains(42)),
                                achievementGridCard(name: achievmentlist[42][1], desription: achievmentlist[42][2], granted: achievments.contains(43)),
                                achievementGridCard(name: achievmentlist[43][1], desription: achievmentlist[43][2], granted: achievments.contains(44)),
                                achievementGridCard(name: achievmentlist[44][1], desription: achievmentlist[44][2], granted: achievments.contains(45)),
                              ],
                            );
                          }
                    })
                  ],
                ),
            )
        )
    );
  }

  Future<List> getYourAchievments() async {
    var response = await functions.getYourAchievments();
    var resp = json.decode(response.body);
    setState(() {
      achievments = resp;
    });
    return resp;
  }

  Future<List> getAchievmentList() async {
    var response = await functions.getAchievmentList();
    var resp = json.decode(response.body);
    setState(() {
      achievmentlist = resp;
    });
    return resp;
  }

  Future<List> guestFuture() async {
    //print("guestHistory()");
    return await new Future(() => [["1970-01-01T00:00:00.000Z","1","2"]]);
  }

}

class achievementGridCard extends StatelessWidget{
  String name;
  String desription;
  bool granted;

  achievementGridCard({required this.name, required this.desription, required this.granted});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: (this.granted) ? Colors.white : Colors.grey,
          boxShadow: [
            BoxShadow(color: Colors.black12,
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3))
          ]),
      child: Column(
        children: [
          Text("${this.name}", style: TextStyle(fontSize: 18,),
            textAlign: TextAlign.center,),
          Spacer(),
          Text("${this.desription}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
          Spacer(),
        ],
      ),
    );
  }
}



