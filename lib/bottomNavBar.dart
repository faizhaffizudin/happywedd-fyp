import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happywedd1/pages/home.dart';
import 'package:happywedd1/pages/toSanding/toSandingAdd.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomBottomNavigationBar(
      {required this.currentIndex,
      required this.onTap,
      required StreamBuilder<QuerySnapshot<Object?>> body});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        //bottom navigation bar
        // bottomNavigationBar: BottomNavigationBar(
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
                      MaterialPageRoute(builder: (builder) => HomePage()));
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
          //     BottomNavigationBarItem(
          //         label: 'Some String',
          //         icon: InkWell(
          //           onTap: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (builder) => const Profile()));
          //           },
          //           child: Icon(
          //             Icons.settings,
          //             size: 32,
          //             color: Colors.white,
          //           ),
          //         )),
          //   ],
          // ),

          // type: BottomNavigationBarType.fixed,
          // backgroundColor: Colors.black87,
          // currentIndex: currentIndex,
          // onTap: onTap,
          // items: [
          //   BottomNavigationBarItem(
          //     label: 'Home',
          //     icon: Icon(
          //       Icons.home,
          //       size: 32,
          //       color: Colors.white,
          //     ),
          //   ),
          //   BottomNavigationBarItem(
          //     label: 'To Sanding',
          //     icon: Icon(
          //       Icons.settings,
          //       size: 32,
          //       color: Colors.white,
          //     ),
          //   ),
          //   BottomNavigationBarItem(
          //     label: 'To Nikah',
          //     icon: Icon(
          //       Icons.add,
          //       size: 32,
          //       color: Colors.white,
          //     ),
          //   ),
          // ],
        ]);
  }
}
