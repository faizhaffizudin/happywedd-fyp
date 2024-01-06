import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happywedd1/bottomNavBar.dart';
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
  // late Stream<QuerySnapshot> _stream;
  List<Select> selected = [];

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? "default_user_id";
    // _stream = FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(userId)
    //     .collection("tosanding")
    //     .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 226, 255),
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "HappyWedd",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      body: _buildHomeContent(context),
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

        DateTime dateNikah = DateTime.now(); // Default value
        DateTime dateSandingBride = DateTime.now(); // Default value
        DateTime dateSandingGroom = DateTime.now(); // Default value

        if (snapshot.hasData) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          if (userData.containsKey("dateNikah")) {
            dateNikah = (userData["dateNikah"] as Timestamp).toDate();
          }
          if (userData.containsKey("dateSandingBride")) {
            dateSandingBride =
                (userData["dateSandingBride"] as Timestamp).toDate();
          }
          if (userData.containsKey("dateSandingGroom")) {
            dateSandingGroom =
                (userData["dateSandingGroom"] as Timestamp).toDate();
          }
        }

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
              countdown: CountdownWidget(targetDate: dateNikah),
            ),
            // SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildCountdownBox(
                    context,
                    title: "Bride Sanding Date",
                    countdown: CountdownWidget(targetDate: dateSandingBride),
                  ),
                ),
                // SizedBox(width: 5),
                Expanded(
                  child: _buildCountdownBox(
                    context,
                    title: "Groom Sanding Date",
                    countdown: CountdownWidget(targetDate: dateSandingGroom),
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
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    decoration: BoxDecoration(
      color: Colors.white,
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
        SizedBox(height: 5),
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
            color: Colors.deepOrange,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "to " + DateFormat('EEEE, dd MMM yyyy').format(targetDate),
          textAlign: TextAlign.center,
          // style: Theme.of(context).textTheme.subtitle1,
          style: TextStyle(
            fontSize: 18,
            color: Colors.purple,
            fontWeight: FontWeight.w700,
          ),
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
