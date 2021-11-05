import 'package:bike_app/functions.dart';
import 'package:bike_app/main.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'splashscreen.dart';
import 'login.dart';

class WelcomeGuide extends StatefulWidget {
  _WelcomeGuide createState() => _WelcomeGuide();
}

class _WelcomeGuide extends State {
  Functions functions = Functions();
  bool guide = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
       Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors:[Color(0xff67bc69), Color(0xff4CAF50)])),
          child:
          SingleChildScrollView(child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: SafeArea( child: Center(
            child:  Column(
              children: [
                Spacer(),
                Text("Welcome to EcoTracker", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),),
                /*Container(padding: EdgeInsets.symmetric(vertical: 30), child: Column(children: [
                  Text("Score Points and save CO2 by riding your bike, skating or walking. All together as a Community against the climat change.\n"),
                  Text("EcoTracker is a way to motivate you, to reduce your carbon footprint. Every kilometer you ride your bike or skates or simplay walk, you earn points.\n"
                      "This way you can compete against other users and earn achievements. You will also help to reach community goals and motivate others."
                      "You can create and join teams to combine your scores and climb the leaderboard.\n"
                      "This way, we can all work together and help to stop the climate change.\n"),
                ]),),*/
                CarouselSlider(
                  options: CarouselOptions(
                      height: 400.0,
                      enableInfiniteScroll: false,
                      viewportFraction:0.8,
                  ),
                  items: [
                    "Score Points and save CO2 by riding your bike, skating or walking. All together as a Community against the climat change.",
                    "EcoTracker is a way to motivate you, to reduce your carbon footprint. Every kilometer you ride your bike or skates or simplay walk, you earn points. This way you can compete against other users and earn achievements.",
                    "You will also help to reach community goals and motivate others. You can create and join teams to combine your scores and climb the leaderboard.",
                    "This way, we can all work together and help to stop the climate change."
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 50.0, right: 15, bottom: 15, left: 15),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                              borderRadius: new BorderRadius.all(Radius.circular(30))
                            ),
                            alignment: Alignment.center,
                            child: Padding(padding: EdgeInsets.all(15), child: Text('$i', style: TextStyle(fontSize: 20.0, color: Colors.white), textAlign: TextAlign.center,),)
                        );
                      },
                    );
                  }).toList(),
                ),






                //Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [Checkbox(value: guide, onChanged: (value) {setState(() {
                    guide = value!;
                  });}),Text("Don't show this again", style: TextStyle(color: Colors.white,))],),
                SizedBox(width: MediaQuery.of(context).size.width*0.8,
                  child: ElevatedButton(onPressed: () {welcomeGuideShown = true; functions.disableWelcomeGuid(guide); Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));}, child: Text("Get Started")),),
                SizedBox(width: MediaQuery.of(context).size.width*0.8,
                  child: ElevatedButton(onPressed: () {welcomeGuideShown = true; functions.disableWelcomeGuid(guide); Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));}, child: Text("Go to Login")),),
                Spacer(),
              ],
            ),),),)
          ),
       )
    );
  }

}