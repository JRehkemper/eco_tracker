import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class Functions {

  Future getPasswordSalt(String name,) async {
    var map = new Map<String, dynamic>();
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(name))
      {
        map['email'] = name;
      }
    else {
      map['username'] = name;
    }
    final response = await http.post(Uri.parse("https://jrehkemper.de/bikeapp/token/salt"), body: map);
    return response;
  }

  Future getLoginRequest(String name, String password) async {
    var map = new Map<String, dynamic>();
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(name))
    {
      map['email'] = name;
    }
    else {
      map['username'] = name;
    }
    map['password'] = password;
    final response = await http.post(Uri.parse(server+"/token/login"),body: map);
    return response;
  }

  Future getAuthTest(String access_token, String refresh_token) async {
    var map = new Map<String, String>();
    map['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    final response = await http.post(Uri.parse(server+"/token/auth"),headers: map);
    print("getAuthTest");
    print(response.body);
    return response;
  }

  Future getRefreshToken(String access_token, String refresh_token) async {
    var map = new Map<String, String>();
    map['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    final response = await http.post(Uri.parse(server+"/token/refresh"),headers: map).timeout(Duration(seconds: 3),
      onTimeout: () {
        print("getRefreshToken Timeout");
        return http.Response('Error', 502);
      });
    print(response.body);
    return response;
  }

  Future getActivationTest(String name) async {
    var map = new Map<String, String>();
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(name))
      {
        print("name is email");
        map['email'] = name;
      }
    else
      {
        print("name is username");
        map['username'] = name;
      }
    final response = await http.post(Uri.parse(server+"/token/activationcheck"),body: map);
    return response;
  }

  Future postEmailCheck(String email) async {
    var map = new Map<String, dynamic>();
    map['email'] = email;
    final response = await http.post(Uri.parse(server+"/token/emailcheck"), body: map);
    return response;
  }

  Future postUsernameCheck(String username) async {
    var map = new Map<String, dynamic>();
    map['username'] = username;
    final response = await http.post(Uri.parse(server+"/token/usercheck"), body: map);
    return response;
  }

  Future postRegister(String email, String username, String password, String salt) async {
    var map = new Map<String, dynamic>();
    map['username'] = username;
    map['password'] = password;
    map['email'] = email;
    map['salt'] = salt;
    final response = await http.post(Uri.parse(server+"/token/registration"),body: map);
    print(response.body);
    return response;
  }

  Future<String> readUsernameFromStorage() async {
    var username = await storage.read(key: "username");
    return username!;
  }

  Future<String> readAccessTokenFromStorage() async {
    var access_token;
    if(!guestLogin) {
      access_token = await storage.read(key: "access_token");
    }
    else {  access_token = ""; }
    return access_token!;
  }

  Future<String> readRefreshTokenFromStorage() async {
    var refresh_token;
    if(!guestLogin) {
      refresh_token = await storage.read(key: "refresh_token");
    }
    else { refresh_token = ""; }
    return refresh_token!;
  }

  Future<String> readSaltFromStorage() async {
    var salt = await storage.read(key: "salt");
    return salt!;
  }

  Future<String> readUserIDFromStorage() async {
    var userID = await storage.read(key: "userID");
    return userID!;
  }

  Future<String> readTeamIDFromStorage() async {
    var teamID = await storage.read(key: "teamID");
    return teamID!;
  }

  Future checkPassword(String oldPassword) async {
    var heads = new Map<String, String>();
    var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    var map = new Map<String, dynamic>();
    map['password'] = oldPassword;
    final response = await http.post(Uri.parse(server+"/token/checkpassword"), headers: heads, body: map);
    return response;
  }

  Future changePassword(String password) async {
    var heads = new Map<String, String>();
    var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    var map = new Map<String, dynamic>();
    map['password'] = password;
    final response = await http.post(Uri.parse(server+"/token/changepassword"), headers: heads, body: map);
    return response;
  }
  
  Future deleteAccount(String username, String email, String password, String salt, String access_token, String refresh_token) async
  {
    var heads = new Map<String, String>();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    var map = new Map<String, dynamic>();
    map['username'] = username;
    map['email'] = email;
    map['password'] = password;
    map['salt'] = salt;
    final response = await http.post(Uri.parse(server+"/token/deleteaccount"), headers: heads, body: map);
    return response;
  }

  Future submitRoute(double distance) async {
    print(distance);
    var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    print("read TeamID");
    var teamID = await readTeamIDFromStorage();
    print(teamID);
    var heads = new Map<String, String>();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    var map = new Map<String, dynamic>();
    map['distance'] = distance.toStringAsFixed(3);
    map['teamid'] = teamID;
    final response = await http.post(Uri.parse(server+"/route/submit"), headers: heads, body: map);
    //print(response.body);
    return response;
  }

  Future getYourScore(userID) async {
    print("UserID");
    print(userID);
    var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    var heads = new Map<String, String>();
    var map = new Map<String, dynamic>();
    map['userID'] = userID;
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    final response = await http.post(Uri.parse(server+"/route/yourscore"), headers: heads, body: map);
    print(response.body);
    return response;
  }

  Future getCommunityScore() async {
    var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    var heads = new Map<String, String>();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    final response = await http.post(Uri.parse(server+"/score/communityscore"), headers: heads);
    return response;
  }

  Future getScoreBoard() async {
    /*var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    var heads = new Map<String, String>();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;*/
    final response = await http.post(Uri.parse(server+"/score/scoreboard"));
    return response;
  }

  Future getTeamsList() async {
    /*var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    var heads = new Map<String, String>();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;*/
    final response = await http.post(Uri.parse(server+"/score/teamslist"));
    return response;
  }

  Future getYourHistory() async {
    var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    var heads = new Map<String, String>();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    final response = await http.post(Uri.parse(server+"/score/yourhistory"), headers: heads);
    //print(response.body);
    return response;
  }

  Future createNewTeam(String teamname) async {
    var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    var heads = new Map<String, String>();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    print("cookie set");
    var userID = await readUserIDFromStorage();
    print(userID);
    var map = new Map<String, dynamic>();
    map['teamname'] = teamname;
    map['UserID'] = userID;
    final response = await http.post(Uri.parse(server+"/score/createteam"), headers: heads, body: map);
    return response;
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
  }

  Future autoLoginStart() async {
    try {
      var access_token = await readAccessTokenFromStorage();
      var refresh_token = await readRefreshTokenFromStorage();
      print("Done Reading Tokens");
      var response = await getRefreshToken(access_token, refresh_token);
      print(response.body);
      Map<String, dynamic> resp = json.decode(response.body);
      access_token = resp['access_token'];
      refresh_token = resp['refresh_token'];
      print("write Tokens to storage");
      storage.write(key: "access_token", value: access_token);
      storage.write(key: "refresh_token", value: refresh_token);

      //var username = await readUsernameFromStorage();
      response = await getAuthTest(access_token, refresh_token);
      print("token valid");
      return response;
    }
    catch (error)
    {
      print(error);
      return http.Response('Error', 403);
    }
  }

  Future welcomeGuidCheck() async {
    var guide = await storage.read(key: "guide");
    if(guide != null) { print("return guide"); return guide; }
    else {
      await storage.write(key: "guide", value: "true");
      return "true";
    }
  }

  void disableWelcomeGuid(bool pguide) async {
    var guide = !pguide;
    print("Guide $guide");
    storage.write(key: "guide", value: guide.toString());
  }

  void showWelcomeGuide() async {
    storage.write(key: "guide", value: "true");
  }

  Future changeTeam(newTeam) async {
    var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    var heads = new Map<String, String>();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    var userID = await readUserIDFromStorage();
    var map = new Map<String, dynamic>();
    map['newteam'] = newTeam;
    map['UserID'] = userID;
    final response = await http.post(Uri.parse(server+"/score/changeteam"), headers: heads, body: map);
    storage.write(key: "teamID", value: newTeam);
    return response;
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print("Location services are disabled");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition();
    print(position);
    return position;
  }

  Future getAchievmentList() async {
    var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    var heads = new Map<String, String>();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    final response = await http.post(Uri.parse(server+"/score/achievmentlist"), headers: heads);
    //print(response.body);
    return response;
  }

  Future getYourAchievments() async {
    var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    var heads = new Map<String, String>();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    final response = await http.post(Uri.parse(server+"/score/yourachievments"), headers: heads);
    //print(response.body);
    return response;
  }

  Future getCommunityRoutes() async {
    /*var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    var heads = new Map<String, String>();
    heads['Cookie'] = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;*/
    final response = await http.post(Uri.parse(server+"/score/communityroutes"));
    //print(response.body);
    return response;
  }

  Future uploadProfileImage(image) async {
    var access_token = await readAccessTokenFromStorage();
    var refresh_token = await readRefreshTokenFromStorage();
    //var heads = new Map<String, String>();
    var heads = "access_token_cookie="+access_token+";refresh_token_cookie="+refresh_token;
    var uri = Uri.parse(server+"/user/uploadProfileImage");
    var userID = await readUserIDFromStorage();
    var request = http.MultipartRequest('POST', uri)
      ..fields['userID'] = userID
      ..headers['Cookie'] = heads
      ..files.add(http.MultipartFile('image',image.readAsBytes().asStream(), image.readAsBytesSync().lengthInBytes, filename: "profilepicture"+userID+".jpg"));
    var response = await request.send();
    //print(response);
    return response;
  }

  Future getProfilePicture(userID) async {
    var map = new Map<String, dynamic>();
    map['UserID'] = userID;
    final response = await http.post(Uri.parse(server+"/user/getProfilePicture"), body: map);
    //print(response.body);
    return response;
  }

  Future getTeamID(userID) async {
    print("UserID "+userID);
    final response = await http.post(Uri.parse(server+"/score/getYourTeam/"+userID));
    print(response.body);
    return response;
  }
}