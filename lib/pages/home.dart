import 'package:flutter/material.dart';
import 'package:happywedd1/pages/signUp.dart';
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
    );
  }
}
