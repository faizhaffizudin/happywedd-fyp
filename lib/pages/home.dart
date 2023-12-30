import 'package:flutter/material.dart';
import 'package:happywedd1/pages/profile.dart';
import 'package:happywedd1/pages/signUp.dart';
import 'package:happywedd1/pages/toSanding/toSanding.dart';
import 'package:happywedd1/pages/toSanding/toSandingAdd.dart';
import 'package:happywedd1/services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authClass.logOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => const SignUp()),
                  (route) => false);
            })
      ]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black87,
        items: [
          //navbar home
          BottomNavigationBarItem(
              label: 'Home',
              icon: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => HomePage()));
                },
                child: Icon(
                  Icons.home,
                  size: 32,
                  color: Colors.white,
                ),
              )),

          //navbar home
          BottomNavigationBarItem(
              label: 'To Sanding',
              icon: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => ToSanding()));
                },
                child: Icon(
                  Icons.settings,
                  size: 32,
                  color: Colors.white,
                ),
              )),

          //navbar add
          BottomNavigationBarItem(
            label: 'To Nikah',
            icon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => ToSandingAdd()));
              },
              // child: Container(
              //   height: 52,
              //   width: 52,
              //   decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       gradient: LinearGradient(colors: [
              //         Colors.indigoAccent,
              //         Colors.purple,
              //       ])),
              child: Icon(
                Icons.add,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),

          //navbar profile
          BottomNavigationBarItem(
              label: 'Profile',
              icon: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => const Profile()));
                },
                child: Icon(
                  Icons.settings,
                  size: 32,
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }
}
