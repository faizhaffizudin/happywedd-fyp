import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happywedd1/bottomNavBar.dart';
import 'package:happywedd1/pages/profile.dart';
import 'package:happywedd1/pages/signUp.dart';
import 'package:happywedd1/pages/toSanding/SandingMain.dart';
import 'package:happywedd1/pages/toSanding/SandingAdd.dart';
import 'package:happywedd1/services/auth.dart';
import 'package:intl/intl.dart';

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
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection("users").doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        DateTime nikahDate = DateTime.now(); // Default value

        if (snapshot.hasData) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          if (userData.containsKey("nikahDate")) {
            nikahDate = (userData["nikahDate"] as Timestamp).toDate();
          }
        }

        Duration countdownDuration = nikahDate.difference(DateTime.now());
        int years = countdownDuration.inDays ~/ 365;
        int months = (countdownDuration.inDays % 365) ~/ 30;
        int days = countdownDuration.inDays % 30;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CountdownWidget(targetDate: nikahDate),
            SizedBox(height: 20),
            // ChecklistCompletionWidget(percentage: 60.0),
          ],
        );
      },
    );
  }
}

class CountdownWidget extends StatelessWidget {
  final DateTime targetDate;

  const CountdownWidget({Key? key, required this.targetDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration countdownDuration = targetDate.difference(DateTime.now());
    int years = countdownDuration.inDays ~/ 365;
    int months = (countdownDuration.inDays % 365) ~/ 30;
    int days = countdownDuration.inDays % 30;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Countdown to Nikah Date",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple[700],
            ),
          ),
          SizedBox(height: 10),
          Text(
            "${years}y ${months}m ${days}d",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.purple[700],
            ),
          ),
          SizedBox(height: 10),
          Text(
            DateFormat('yyyy-MM-dd').format(targetDate),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.purple[700],
            ),
          ),
        ],
      ),
    );
  }
}

class ChecklistCompletionWidget extends StatelessWidget {
  final double percentage;

  const ChecklistCompletionWidget({Key? key, required this.percentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // Wrap in Center widget
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Checklist Completion",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple[700],
            ),
          ),
          SizedBox(height: 10),
          Text(
            "$percentage% completed",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.purple[700],
            ),
          ),
        ],
      ),
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
