import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happywedd1/bottomNavBar.dart';
import 'package:happywedd1/pages/profile.dart';
import 'package:happywedd1/pages/signUp.dart';
import 'package:happywedd1/pages/toSanding/SandingMain.dart';
import 'package:happywedd1/pages/toSanding/SandingAdd.dart';
import 'package:happywedd1/services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  late String userId;
  late Stream<QuerySnapshot> _stream;
  List<Select> selected = [];
  int _currentIndex = 0; // Set the default index to Home

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? "default_user_id";
    _stream = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("tosanding")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authClass.logOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => const SignUp()),
                (route) => false,
              );
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      body: _buildHomeContent(),
    );
  }

  Widget _buildHomeContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CountdownWidget(targetDate: DateTime(2023, 12, 31)),
          SizedBox(height: 20),
          ChecklistCompletionWidget(percentage: 60.0),
        ],
      ),
    );
  }
}

class CountdownWidget extends StatelessWidget {
  final DateTime targetDate;

  const CountdownWidget({Key? key, required this.targetDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration countdownDuration = targetDate.difference(DateTime.now());
    int days = countdownDuration.inDays;

    return Column(
      children: [
        Text(
          "Countdown to Wedding",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.purple[700],
          ),
        ),
        SizedBox(height: 10),
        Text(
          "$days days",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.purple[700],
          ),
        ),
      ],
    );
  }
}

class ChecklistCompletionWidget extends StatelessWidget {
  final double percentage;

  const ChecklistCompletionWidget({Key? key, required this.percentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Checklist Completion",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.purple[700],
          ),
        ),
        SizedBox(height: 10),
        Text(
          "$percentage% completed",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.purple[700],
          ),
        ),
      ],
    );
  }
}

class Select {
  String id;
  bool checkValue = false;

  Select({required this.id, required this.checkValue});
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
