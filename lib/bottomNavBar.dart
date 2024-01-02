// bottomNavigationBar: BottomNavBar(currentIndex: ),

import 'package:flutter/material.dart';
import 'package:happywedd1/pages/home.dart';
import 'package:happywedd1/pages/profile.dart';
import 'package:happywedd1/pages/toSanding/SandingMain.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  const BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        // Navigate to the corresponding pages based on the index
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 1:
            // Navigate to To Nikah page
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ToSanding()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
            break;
        }
      },
      backgroundColor: Colors.purple[700], // Background color
      selectedItemColor: Colors.white, // Selected item label and icon color
      unselectedItemColor: Color.fromARGB(255, 185, 144, 202),
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'To Nikah',
          icon: Icon(Icons.diamond),
        ),
        BottomNavigationBarItem(
          label: 'To Sanding',
          icon: Icon(Icons.favorite),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.account_circle),
        ),
      ],
    );
  }
}
