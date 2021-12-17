import 'dart:convert';

import 'package:bike_app/functions.dart';
import 'package:flutter/material.dart';

import 'profile.dart';
import 'main.dart';

class LeaderBoard extends StatefulWidget
{
  @override
  _LeaderBoard createState() => _LeaderBoard();
}

class _LeaderBoard extends State
{
  Functions functions = new Functions();
  late Future<List> leaderboardFuture;
  var leaderboard;

  @override
  void initState() {
    super.initState();
    leaderboardFuture = getLeaderboard();
    leaderboard = getLeaderboard();
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
    )
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
              appBar: AppBar(/*title: Text("Leaderboard"),*/),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Center(
                  child: Column(children: [
                    Padding(padding: EdgeInsets.only(top: 0), child: Text("Leaderboard", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),),
                    ListTile(title: Text("Username", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),), trailing: Text("Distance in Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),),
                    FutureBuilder(future: leaderboardFuture, builder: (context, AsyncSnapshot snapshot) {
                      if(!snapshot.hasData)
                      {
                        return Center(child: CircularProgressIndicator());
                      }
                      else
                      {
                        return ListView.builder(shrinkWrap:true, physics: NeverScrollableScrollPhysics(), itemCount: leaderboard.length, itemBuilder: (BuildContext context, int index)
                        {
                          return InkWell(
                            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfileScreen(leaderboard[index][2])));},
                            child: ListTile(
                              leading: Text("${index + 1}."),
                              title: Row(children: [
                                ClipOval(
                                  child: Image.network(server+"/user/getProfilePicture/"+leaderboard[index][2].toString(), fit: BoxFit.cover, height: 40, width: 40,),
                                ),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                Text("${leaderboard[index][0]}", style: TextStyle(fontSize: 14))],),
                              trailing: Text((leaderboard[index][1] == null)?"0.000":"${leaderboard[index][1]}"),
                          ),);
                        });
                      }
                    }),
                  ],)
              ),)
          )
    );
  }

  Future<List> getLeaderboard() async {
    var response = await functions.getScoreBoard();
    var resp = json.decode(response.body);
    //print(resp);
    setState(() {
      leaderboard = resp;
    });
    return resp;
  }

}