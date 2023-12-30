import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();
  late XFile image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/google.svg"),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  uploadBtn(),
                  IconButton(
                      onPressed: () async {
                        image = (await _picker.pickImage(
                            source: ImageSource.gallery))!;
                        setState(() {
                          image = image;
                        });
                      },
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.teal,
                        size: 30,
                      ))
                ],
              )
            ],
          ),
        )));
  }

  ImageProvider getImage() {
    return FileImage(File(image.path));
    // return AssetImage("assets/google.svg");
  }

  Widget uploadBtn() {
    return InkWell(
        onTap: () {},
        child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: RadialGradient(colors: [
                  Colors.lightBlue,
                  Colors.lightGreen,
                ])),
            child: Center(
                child: Text("Upload",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )))));
  }
}
