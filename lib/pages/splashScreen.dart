import 'package:flutter/material.dart';
import 'package:happywedd1/pages/signIn.dart';
import 'package:happywedd1/services/auth.dart';

class SplashScreen extends StatefulWidget {
  final String text;

  const SplashScreen({super.key, required this.text});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthClass authClass = AuthClass();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      // Auto sign-in user
      await authClass.autoSignIn(context);

      // Navigate to SignIn screen if the user is not signed in
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (builder) => SignIn()),
        (route) => false,
      );
    });
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
            end: Alignment.bottomLeft,
          ),
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
            ),
          ],
        ),
      ),
    );
  }
}
