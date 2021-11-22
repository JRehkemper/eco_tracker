
import 'dart:convert';

import 'package:flutter/material.dart';

import 'functions.dart';

class CO2Screen extends StatefulWidget {
  _CO2Screen createState() => _CO2Screen();
}

class _CO2Screen extends State {
  Functions functions = Functions();
  var yourScore = 0.0;
  var communityScore = 0.0;
  var yourPart = 0.0;

  void initState() {
    super.initState();
    calculateNumbers().then((value) {
      setState(() {
        yourPart = (100/communityScore*yourScore).round().toDouble();
      });
      print(yourScore);
      print(communityScore);
      print(yourPart);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Saved CO2")),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 15),
                Card(child: SizedBox(height: 100, width: MediaQuery.of(context).size.width*0.9,
                  child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text("The EcoTracer-Community saved", style: TextStyle(fontSize: 18),),
                      Spacer(),
                      Text("$communityScore Kg CO2", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                      Spacer(),
                    ],
                  )),
                ),),
                Card(child: SizedBox(height: 100, width: MediaQuery.of(context).size.width*0.9,
                  child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text("You saved", style: TextStyle(fontSize: 18),),
                      Spacer(),
                      Text("$yourScore Kg CO2", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                      Spacer(),
                    ],
                  )),
                ),),
                Card(child: SizedBox(height: 100, width: MediaQuery.of(context).size.width*0.9,
                  child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text("You contributed", style: TextStyle(fontSize: 18),),
                      Spacer(),
                      Text("$yourPart%", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                      Spacer(),
                    ],
                  )
            ),
          ),),
        ],)


    ),),);
  }

  Future calculateNumbers() async {
    var userID = await functions.readUserIDFromStorage();
    var response = await functions.getYourScore(userID);
    if(response.statusCode != 200) {return;}
    var resp = json.decode(response.body);
    setState(() {
    var tmpYourScore = (resp['totalDistance']*128.1/1000).toStringAsFixed(3);
    yourScore = double.parse(tmpYourScore);
    });
    print("YourScore");
    response = await functions.getCommunityScore();
    if(response.statusCode != 200) {return;}
    resp = json.decode(response.body);
    setState(() {
    var tmpCommunityScore = (resp['distance']*128.1/1000).toStringAsFixed(3);
    communityScore = double.parse(tmpCommunityScore);
    });
    print("communityScore");
    return null;
  }

}