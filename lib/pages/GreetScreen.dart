import 'package:flutter/material.dart';
import 'package:happywedd1/pages/home.dart';

class GreetScreen extends StatefulWidget {
  // final Widget? child;
  const GreetScreen({super.key});

  @override
  State<GreetScreen> createState() => _GreetScreenState();
}

class _GreetScreenState extends State<GreetScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);
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
            children: const [
              Icon(
                Icons.people,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'Preparing your Account...',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontSize: 32,
                ),
              )
            ]),
      ),
    );
  }
}
