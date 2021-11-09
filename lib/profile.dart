import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'functions.dart';

class ProfileScreen extends StatefulWidget {
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State {

  Functions functions = new Functions();
  late PickedFile? _image;
  late File fileImage;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      fileImage = image;
    });
    functions.uploadProfileImage(fileImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),),
      body: SafeArea(
          child: Column(children: [
            Spacer(),
            Center(
              child: ElevatedButton(
                  onPressed: ()  {
                    getImage();
                  },
                  child: Text("Upload Profile Image")),
            ),
            Spacer(),
          ],))
    );
  }

}