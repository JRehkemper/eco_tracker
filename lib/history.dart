import 'dart:convert';

import 'package:bike_app/functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget
{
  @override
  _HistoryScreen createState() => _HistoryScreen();
}

class _HistoryScreen extends State
{
  Functions functions = new Functions();
  late Future<List> historyFuture;
  var history;

  @override
  void initState() {
    super.initState();
    historyFuture = getYourHistory();
    history = getYourHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Your last routes"),),
      body: Center(
        child: Column(children: [
          Padding(padding: EdgeInsets.only(top: 15), child: Text("Your History", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),),
          ListTile(title: Text("Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),), trailing: Text("Distance in Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),),
          FutureBuilder(future: historyFuture, builder: (context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData)
          {
            return Center(child: CircularProgressIndicator());
          }
          else
          {
            return ListView.builder(shrinkWrap:true, itemCount: history.length, itemBuilder: (BuildContext context, int index)
            {
              return ListTile(
                title:Text("${DateFormat('dd.MM.yyyy - kk:mm').format(DateTime.parse(history[index][2]))}", style: TextStyle(fontSize: 14),),
                trailing: Text("${history[index][1]}"),
              );
            });
          }
        }),
        ],)
      )
    );
  }

  Future<List> getYourHistory() async {
    var response = await functions.getYourHistory();
    var resp = json.decode(response.body);
    setState(() {
      history = resp;
    });
    return resp;
  }

}