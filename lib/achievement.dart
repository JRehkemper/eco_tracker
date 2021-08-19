import 'dart:convert';

import 'package:bike_app/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO: Create Achievements

class AchievementScreen extends StatefulWidget {
  _AchievementScreen createState() => _AchievementScreen();
}

class _AchievementScreen extends State {

  Functions functions = Functions();
  late Future<List> achievments_future;
  var achievments;
  var achievmentlist;
  /*ValueNotifier<double> vscore = ValueNotifier(0.0);
  var score = 0.0;*/

  @override
  void initState() {
    super.initState();
    achievments_future = getYourAchievments();
    getYourAchievments().then((response) {
      var arr = [];
      int i = 0;
      while(i < response.length)
      {
        arr.add(response[i][0]);
        i++;
      }
      //achievments_future = response;
      achievments = arr;
    });
    getAchievmentList().then((response) {
      achievmentlist = response;
    });
    print("end of init");
    /*functions.getYourScore().then((response) {
      if (response.statusCode != 200) {
        return;
      }
      var resp = json.decode(response.body);
      setState(() {
        //score = resp['total Distance'];
        if(resp['totalDistance'] == null)
          {
            vscore = ValueNotifier(0.0);
            score = 0.0;
          }
        else {
          vscore = ValueNotifier(resp['totalDistance']);
          score = resp['totalDistance'];
        }

      });
      print("Score updated");
      print(score);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Achievements")),
      body: SafeArea(child: SingleChildScrollView(
        child: Column(children: [
            Padding(padding: EdgeInsets.only(top: 15), child: Text("Achievements", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),),
            FutureBuilder(future: achievments_future, builder: (context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData)
              {
                return Center(child: CircularProgressIndicator());
              }
              else
              {
                return GridView.builder(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
                  itemCount: achievmentlist.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return  Container(width: MediaQuery.of(context).size.width*0.4, height: MediaQuery.of(context).size.width*0.4, margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color:(achievments.contains(index+1))? Colors.white: Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                    child: Column(children: [
                      Text("${achievmentlist[index][1]}", style: TextStyle(fontSize: 16,), textAlign: TextAlign.center,),
                      Text("${achievmentlist[index][2]}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              ],),);
              });

            /*GridView.count(physics: NeverScrollableScrollPhysics(), shrinkWrap: true, crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 10, padding: EdgeInsets.all(10),
              children: [
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (score > 1)?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("First Step", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("Collect your first Kilometer.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),),
                Container(margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (score > 7.8)?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("1 KG", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("You saved 1 KG CO2", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),),
                Container(margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (score > 78)?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("10 KG", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("You saved 10 KG CO2", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),),
                Container(margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (score > 100)?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("100Km", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("Drive 100Km", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),),
                Container(margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (score > 500)?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("500Km", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("Drive 500Km", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),),
                Container(margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (score > 780)?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("100 KG", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("You saved 100 KG CO2", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),),
                Container(margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (score > 1000)?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("1000Km", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("Drive 1000Km", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),),
                Container(margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (score > 3900)?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("500 KG", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("You saved 500 KG CO2", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),),
                Container(margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (score > 7800)?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("1000 KG", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("You saved 1000 KG CO2", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),),
              ],)*/

        };}),
    ]))));
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

}