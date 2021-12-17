import 'dart:async';
import 'package:bike_app/main.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'home.dart';

//TODO: Help Overlay

void topLevelTest() {
  DateTime now = DateTime.now();
  //print(DateFormat('kk:mm:ss').format(now));
}

class RouteScreen extends StatefulWidget {
  @override
  _RouteScreen createState() => _RouteScreen();
}

class _RouteScreen extends State {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        Text("Record your Route", style: TextStyle(fontSize: 40),),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text("Click start and we will begin to record your distance. Every Kilometer will be added to your Score and the Score of your Team. You will also start to earn Achievements."),
        ),
        ElevatedButton(onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RouteRecording()));}, child: Text("Start")),
      ],),
    );
  }

}

class RouteRecording extends StatefulWidget {
  @override
  _RouteRecording createState() => _RouteRecording();
}

class _RouteRecording extends State {

  Functions functions = new Functions();
  var recording = false;
  var counter = 0;
  var entries = [];
  late Timer rectimer;
  late Timer postimer;
  var mapPosition = LatLng(51.5, -0.09);
  var position;
  MapController mapController = MapController();
  var lastRecord;
//late MapController mapController;
  final Distance distance = Distance();
  double distanceInKM = 0.0;
  var now = DateTime.now();
  bool positionfound = false;
  final positionSnackbar = SnackBar(content: Text("Please wait until your position is found"));
  final startSnackbar = SnackBar(content: Text("Recording started"));
  final stopSnackbar = SnackBar(content: Text("Recording stopped"));
  final submitSnackbar = SnackBar(content: Text("Your route was recieved and confirmed"));
  final submitErrSnackbar = SnackBar(content: Text("Error while submitting your Route"));

  @override
  void initState() {
    super.initState();
    initMap();
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
    child:Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("Record your Route"),
      IconButton(onPressed: () {showAlertDialogNoButton(context, "Help", "");}, icon: Icon(Icons.help_outline))
    ],),
      leading: IconButton(onPressed: () {
        if(!positionfound) {
          stopRecording();
          postimer.cancel();

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) {
            return HomeScreen();
            },), (route)=> false,);
        } else {
          confirmRoute();
        }}, icon: Icon(Icons.arrow_back)),),
    body: Center(
      child: Column(children: [
        /*Text("When you hit Start, we will record your Route in Intervals"),
        Text("Number of Entries ${counter}"),
        Text("Distance in Meter ${distanceInKM}"),
        Text("Last recorded Position ${DateFormat('kk:mm:ss').format(now)}"),*/
      /*OSMFlutter(
        controller:mapController,
        trackMyPosition: false,
        road: Road(
          startIcon: MarkerIcon(
            icon: Icon(
              Icons.person,
              size: 64,
              color: Colors.brown,
            ),
          ),
          roadColor: Colors.yellowAccent,
        ),
        markerOption: MarkerOption(
            defaultMarker: MarkerIcon(
              icon: Icon(
                Icons.person_pin_circle,
                color: Colors.blue,
                size: 56,
              ),
            )
        ),
      ),*/
        Container(height: MediaQuery.of(context).size.height,
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: mapPosition,
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: mapPosition,
                    builder: (ctx) =>
                        Container(
                          child: Icon(Icons.person_pin_circle, size: 50, color: Colors.red,),
                        ),
                  ),
                ],
              ),
            ],
        ),),

      ],),
    ),
      floatingActionButton: Padding(padding: EdgeInsets.all(0), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)), color: Colors.green),
              child: Padding(padding: EdgeInsets.only(top: 15, right: 35, bottom: 15, left: 45),
                child: Column(children: [
                  Text("Total Distance"),
                  Text("ca ${distanceInKM.toStringAsFixed(3)} km"),
                ],)
              )
            ),
          ]),
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            /*Padding(padding: EdgeInsets.symmetric(vertical: 5),
              child: FloatingActionButton(onPressed: () {showAlertDialogNoButton(context, "Help",
                "");}, child: Icon(Icons.help_outline),),),*/
            Padding(padding: EdgeInsets.symmetric(vertical: 5),
              child: FloatingActionButton(onPressed: () {if(!positionfound){ScaffoldMessenger.of(context).showSnackBar(positionSnackbar); return;} startRecording();}, child: Icon(recording? Icons.pause : Icons.fiber_manual_record),),),
            /*Padding(padding: EdgeInsets.symmetric(vertical: 5),
              child: FloatingActionButton(onPressed: () {if(!positionfound){ScaffoldMessenger.of(context).showSnackBar(positionSnackbar); return;} resetRecording();}, child: Icon(Icons.repeat),),),*/
            Padding(padding: EdgeInsets.symmetric(vertical: 5),
              child: FloatingActionButton(onPressed: () {confirmRoute();}, child: Icon(Icons.check),),),
          ],),
      ],),),
    )
    );
  }

  void confirmRoute() {
    if (!positionfound) {
      ScaffoldMessenger.of(context).showSnackBar(positionSnackbar);
      return;
    }
    stopRecording();
    showAlertDialogTwoButton(context, "Confirm Route", "Do you want to stop and submit your Route?\nWe will only recieve how far you drove. No positiondata will be sent.");
  }

  void startForegroundService() async {
    await ForegroundService.setServiceIntervalSeconds(5);
    await ForegroundService.notification.startEditMode();
    await ForegroundService.notification.setTitle("EcoTracker is recording your Route");
    await ForegroundService.notification.setText("You are now collecting Kilometers.");
    await ForegroundService.notification.finishEditMode();
    await ForegroundService.startForegroundService(topLevelTest);
    await ForegroundService.getWakeLock();
  }

  void startRecording() async {

    if(!recording) {
      ScaffoldMessenger.of(context).showSnackBar(startSnackbar);
      print("start");
      setState(() {
        recording = true;
      });
      rectimer = Timer.periodic(Duration(seconds: 5), (Timer t) async
      {
        setState(() {
          recordPosition();
        });
      });
      //startForegroundService();
    }
    else if(recording) {
      stopRecording();
    }
  }

  void stopRecording() async {
    if(recording) {
      ScaffoldMessenger.of(context).showSnackBar(stopSnackbar);
    }
    await ForegroundService.stopForegroundService();
    print("stop");
    rectimer.cancel();
    setState(() {
      recording = false;
    });
    calculateDistanceMeter();
  }

  void resetRecording() async {
    stopRecording();
    rectimer.cancel();
    print("reset");
    await ForegroundService.stopForegroundService();
    setState(() {
      entries = [];
      counter = entries.length;
      distanceInKM = 0;
    });
  }

  void recordPosition() async {
    setState(() {
      now = DateTime.now();
      calculateDistanceMeter();
      print(position);
      print(counter);
      counter = entries.length;
      recording = true;
      //mapController.changeLocation(position);
      lastRecord = DateTime.now();
    });
  }

  void getPosition() async {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position newposition) {
      setState(() {
        position = newposition;
        mapPosition = LatLng(position.latitude, position.longitude);
        mapController.move(mapPosition, 18);
        //print("setPosition");
        if(!positionfound)
          {
            positionfound = true;
            print("position found");
            startRecording();
          }
      });
    });
  }

  void initMap() async {
    await functions.determinePosition();
    postimer = Timer.periodic(Duration(seconds: 1), (Timer t) async
    {
      getPosition();
    });
    if(!guestLogin) {
      startForegroundService();
    }
  }

  void calculateDistanceMeter()
  {
    if(entries.length > 1) {
      var dist = distance(LatLng(
          entries[entries.length-1].latitude, entries[entries.length-1].longitude),
          LatLng(position.latitude, position.longitude));
      var time = now.difference(lastRecord).inSeconds;
      //print("speed: ${dist/time}");
      if (dist / time < 11.1111) {
        distanceInKM += dist / 1000;
      }
      else {
        //print("you are too fast");
      }
    }
    entries.add(position);
  }

  void showAlertDialogTwoButton(BuildContext context, String title, String text)  {
    // set up the button
    Widget button_1 = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        print("pressed");
        var response = await functions.submitRoute(distanceInKM);
        print(response.body);
        if(response.statusCode == 200)
          {
            ScaffoldMessenger.of(context).showSnackBar(submitSnackbar);
            resetRecording();
            Navigator.pop(context);
            postimer.cancel();
            try{
              rectimer.cancel();
            } catch (error) {}
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) {
              return HomeScreen();
            },), (route)=> false,);
          }
        else
          {
            ScaffoldMessenger.of(context).showSnackBar(submitErrSnackbar);
            storage.write(key: "lastRoute", value: distanceInKM.toString());
          }
        },
    );
    Widget button_2 = TextButton(
      child: Text("Delete Route"),
      onPressed: ()  {
        resetRecording();
        postimer.cancel();
        try {
          rectimer.cancel();
        }
        catch (error) {}
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) {
           return HomeScreen();
           },), (route)=> false,);
      },
    );
    Widget button_3 = TextButton(
      child: Text("Cancle"),
      onPressed: () => Navigator.pop(context),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        button_1,
        button_2,
        button_3
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

  void showAlertDialogNoButton(BuildContext context, String title, String text)  {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text("EcoTracker will Record your Distance as soon as your GPS Location is detected.\nIf you want to submit your route, click on the checkmack in the bottom right.\nYou can Pause and Continue the recording with the Button above."),
      actions: [
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