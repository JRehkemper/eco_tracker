import 'package:bike_app/functions.dart';
import 'package:bike_app/main.dart';
import 'package:flutter/material.dart';

import 'splashscreen.dart';

class WelcomeGuide extends StatefulWidget {
  _WelcomeGuide createState() => _WelcomeGuide();
}

class _WelcomeGuide extends State {
  Functions functions = Functions();
  bool guide = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(child:
       Container(margin: EdgeInsets.all(40),
          child:
          Center(
            child:  Column(
              children: [
                Text("Welcome to EcoTracker", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                Container(padding: EdgeInsets.symmetric(vertical: 30), child: Column(children: [
                  Text("Score Points and save CO2 by riding your bike, skating or walking. All together as a Community against the climat change.\n"),
                  Text("EcoTracker is a way to motivate you, to reduce your carbon footprint. Every kilometer you ride your bike or skates or simplay walk, you earn points.\n"
                      "This way you can compete against other users and earn achievements. You will also help to reach community goals and motivate others."
                      "You can create and join teams to combine your scores and climb the leaderboard.\n"
                      "This way, we can all work together and help to stop the climate change.\n"),
                ]),),






                Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [Checkbox(value: guide, onChanged: (value) {setState(() {
                    guide = value!;
                  });}),Text("Don't show this again")],),
                ElevatedButton(onPressed: () {welcomeGuideShown = true; functions.disableWelcomeGuid(guide); Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));}, child: Text("Continue")),
              ],
            ),)
          ),

      ),
    );
  }

}