import 'package:flutter/material.dart';
import 'package:happywedd1/bottomNavBar.dart';
import 'package:happywedd1/pages/toSanding/toSandingBride/sandingBrideMain.dart';
import 'package:happywedd1/pages/toSanding/toSandingGroom/sandingGroomMain.dart';
import 'package:happywedd1/pages/toSanding/weddingPackage/sandingPackages.dart';

class ToSanding extends StatefulWidget {
  ToSanding({Key? key}) : super(key: key);

  @override
  _ToSandingState createState() => _ToSandingState();
}

class _ToSandingState extends State<ToSanding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 226, 255),
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        title: Text(
          "To Sanding",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ToSandingBride()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple[600],
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.face_2,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Go to Bride Sanding",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ToSandingGroom()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple[600],
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.face,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Go to Groom Sanding",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => sandingPackages()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple[600],
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "View Wedding Packages",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
