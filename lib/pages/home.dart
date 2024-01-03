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
     return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
       colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.purpleAccent),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple,
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.purple,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          subtitle1: TextStyle(
            color: Colors.purple,
            fontSize: 18,
          ),
          // Add more text styles as needed
        ),
      ),
      home: Scaffold(
       backgroundColor: const Color.fromARGB(255, 239, 226, 255),
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Home",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
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
      body: _buildHomeContent(context),
    ),
     );
  }

  Widget _buildHomeContent(BuildContext context) {
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
             Center(
              child: Text(
                "Countdowns",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 53, 41, 95),
                ),
              ),
            ),
            _buildCountdownBox(
              context,
              title: "Nikah Date",
              countdown: CountdownWidget(targetDate: nikahDate),
            ),
            SizedBox(height: 20),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
              child: _buildCountdownBox(
              context,
              title: "Bride Sanding Date",
              countdown: CountdownWidget(targetDate: nikahDate),
            ),
                ),
            SizedBox(height: 20),
             Expanded(
              child: _buildCountdownBox(
              context,
              title: "Groom Sanding Date",
              countdown: CountdownWidget(targetDate: nikahDate),
            ),
             ),
              ],
             ),
            SizedBox(height: 20),
            // ChecklistCompletionWidget(percentage: 60.0),
          ],
        );
      },
    );
  }
}

Widget _buildCountdownBox(BuildContext context,
{required String title, required Widget countdown}) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        border: Border.all(color: Colors.purple),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
            // style: TextStyle(
            //   fontSize: 24,
            //   fontWeight: FontWeight.bold,
            //   color: Colors.purple[700],
            // ),
          ),
          SizedBox(height: 10),
          countdown,
        ],
      ),
    );
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

    return Column(
      children: [
        Text(
          "${years}y ${months}m ${days}d",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
          SizedBox(height: 10),
          Text(
            DateFormat('yyyy-MM-dd').format(targetDate),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
            // style: TextStyle(
            //   fontSize: 18,
            //   color: Colors.purple[700],
            // ),
          ),
          SizedBox(height: 10),
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
