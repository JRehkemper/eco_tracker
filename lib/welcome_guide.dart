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
      body: SafeArea(
        child: Container(margin: EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                Text("Welcome to EcoTracker", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                Container(padding: EdgeInsets.symmetric(vertical: 20), child: Text("EcoTracker is a small project to motivate you, to leave your car at home and go by bike. This way you can help to safe some CO2 and safe the climate.\n\n"
                    "Of course Skateboards, Inline Skates or any other vehicle does count as well, as long as you do not produce CO2 emissions.\n\n"
                    "By tracking your routes and tours, you will collect Kilometers and earn Achievements. You will also climb the leaderboard and compare yourself with others.\n\n"
                    "You could also join a team and climb the leaderboard as a group.\n\n"
                    "This app is only a small project, but every little bit helps to stop the climate change.\n"
                    "And together we can do this with just a little afford and alot of fun."),),
                Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [Checkbox(value: guide, onChanged: (value) {setState(() {
                    guide = value!;
                  });}),Text("Don't show this again")],),
                ElevatedButton(onPressed: () {welcomeGuideShown = true; functions.disableWelcomeGuid(guide); Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));}, child: Text("Continue")),
              ],
            ),
          ),
        )
      )
    );
  }

}