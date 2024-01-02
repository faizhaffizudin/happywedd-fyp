import 'dart:io';
import 'package:flutter/material.dart';
import 'package:happywedd1/bottomNavBar.dart';
import 'package:happywedd1/pages/splashScreen.dart';
import 'package:happywedd1/services/auth.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthClass authClass = AuthClass();
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  TextEditingController _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(actions: [
        IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authClass.logOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => const SplashScreen()),
                  (route) => false);
            })
      ]),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: getImage(),
              ),
              SizedBox(height: 20),
              _buildUserNameSection(),
              SizedBox(height: 30),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserNameSection() {
    return Column(
      children: [
        Text(
          'John Doe', // Replace with the user's actual name
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _userNameController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Edit Name',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Implement the action for the Upload button
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.lightBlue,
            onPrimary: Colors.white,
          ),
          child: Text('Upload'),
        ),
        SizedBox(width: 20),
        ElevatedButton.icon(
          onPressed: () async {
            XFile? pickedImage = await _picker.pickImage(
              source: ImageSource.gallery,
            );
            if (pickedImage != null) {
              setState(() {
                image = pickedImage;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.teal,
            onPrimary: Colors.white,
          ),
          icon: Icon(Icons.add_a_photo),
          label: Text('Change Photo'),
        ),
      ],
    );
  }

  ImageProvider<Object> getImage() {
    return image != null
        ? FileImage(File(image!.path))
        : AssetImage("assets/google.svg") as ImageProvider<Object>;
  }
}
