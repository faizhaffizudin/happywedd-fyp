import 'package:flutter/material.dart';
import 'package:happywedd1/pages/signIn.dart';

class SplashScreen extends StatefulWidget {
  final String text;
  // final Widget? child;
  const SplashScreen({super.key, required this.text});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (builder) => SignIn()), (route) => false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 5, // Adjust the border width as needed
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10), // Adjust the border radius as needed
                ),
              ),
              child: Image.asset(
                'assets/happyweddlogo.png',
                width: 80,
                height: 80,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to\nHappyWedd',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white,
                fontSize: 32,
              ),
            )
          ],
        ),
      ),
    );
  }
}
