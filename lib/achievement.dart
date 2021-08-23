import 'dart:convert';

import 'package:bike_app/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      //print("achievments $achievments");
    });
    getAchievmentList().then((response) {
      achievmentlist = response;
      //print("achievmentsList $achievmentlist");
    });


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
            /*FutureBuilder(future: achievments_future, builder: (context, AsyncSnapshot snapshot) {
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
              });*/

            GridView.count(physics: NeverScrollableScrollPhysics(), shrinkWrap: true, crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 10, padding: EdgeInsets.all(10),
              children: [
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(1))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[0][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[0][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(2))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[1][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[1][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(3))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[2][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[2][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(4))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[3][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[3][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(5))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[4][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[4][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(6))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[5][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[5][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(10))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[9][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[9][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(11))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[10][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[10][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(12))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[11][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[11][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(13))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[12][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[12][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(14))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[13][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[13][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(15))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[14][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[14][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(16))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[15][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[15][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(20))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[19][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[19][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(21))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[20][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[20][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(22))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[21][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[21][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(30))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[29][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[29][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(31))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[30][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[30][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(32))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[31][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[31][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(33))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[32][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[32][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(34))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[33][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[33][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(40))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[39][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[39][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(41))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[40][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[40][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(42))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[41][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[41][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(43))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[42][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[42][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(44))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[43][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[43][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),
                Container( margin: EdgeInsets.all(5), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (achievments.contains(45))?Colors.white : Colors.grey, boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 5, offset: Offset(0,3))]),
                  child: Column(children: [
                    Text("${achievmentlist[44][1]}", style: TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
                    Spacer(),
                    Text("${achievmentlist[44][2]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Spacer(),
                  ],),
                ),

              ],),
              ],),
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

}