import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happywedd1/bottomNavBar.dart';
import 'package:happywedd1/pages/listCard.dart';
import 'package:happywedd1/pages/toSanding/toSandingGroom/sandingGroomAdd.dart';
import 'package:happywedd1/pages/toSanding/toSandingGroom/sandingGroomBudget.dart';
import 'package:happywedd1/pages/toSanding/toSandingGroom/sandingGroomItinerary.dart';
import 'package:happywedd1/pages/toSanding/toSandingGroom/sandingGroomView.dart';
import 'package:happywedd1/services/auth.dart';

class ToSandingGroom extends StatefulWidget {
  ToSandingGroom({super.key});

  @override
  _ToSandingGroomState createState() => _ToSandingGroomState();
}

class _ToSandingGroomState extends State<ToSandingGroom> {
  AuthClass authClass = AuthClass();
  late String userId;
  late Stream<QuerySnapshot> _stream;
  List<Select> selected = [];

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? "default_user_id";
    _stream = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("sandinggroomList") // CHANGE
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 239, 226, 255), // Changed background color to deep purple
      appBar: AppBar(
        backgroundColor: Colors.purple[700], // Changed app bar color to purple
        title: Text(
          "Groom To Sanding", // Updated the title
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                FractionallySizedBox(
                  widthFactor: 0.75,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SandingGroomItinerary(userId: userId)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple[
                          600], // Changed the button color to deep purple
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Groom Sanding Itinerary",
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
                FractionallySizedBox(
                  widthFactor: 0.73,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SandingGroomBudget(userId: userId)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple[
                          300], // Changed the button color to soft purple
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.attach_money, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Groom Sanding Budget",
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
              ],
            ),
            // SizedBox(height: 50),
            Center(
              child: Text(
                "Checklist",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 53, 41, 95),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SandingGroomAdd()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Colors.purple[500], // Changed the button color to purple
                  padding: EdgeInsets.all(13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 0.5),
                    Text(
                      "Sanding Checklist",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                        // height: 20,
                        ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        "No checklist made yet...",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }
                  // Convert the documents to a list and sort by due date
                  List<DocumentSnapshot> sortedList = snapshot.data!.docs;
                  sortedList.sort((a, b) {
                    Timestamp timestampA = a['duedate'];
                    Timestamp timestampB = b['duedate'];
                    return timestampA.compareTo(timestampB);
                  });
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(), // Added this line
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      IconData iconData;
                      Color iconColor;
                      Map<String, dynamic> document =
                          sortedList[index].data() as Map<String, dynamic>;
                      switch (document["category"]) {
                        case "Venue":
                          iconData = Icons.home;
                          iconColor = Colors.lightBlue;
                          break;
                        case "Caterer":
                          iconData = Icons.restaurant;
                          iconColor = Colors.brown;
                          break;
                        case "Vendors":
                          iconData = Icons.fastfood;
                          iconColor = Colors.deepOrange;
                          break;
                        case "Guest List":
                          iconData = Icons.groups_2;
                          iconColor = Colors.blueGrey;
                          break;
                        case "Invitation Card":
                          iconData = Icons.rsvp;
                          iconColor = Colors.pink;
                          break;
                        case "Safety":
                          iconData = Icons.healing;
                          iconColor = Colors.amber;
                          break;
                        case "Others":
                          iconData = Icons.more_horiz;
                          iconColor = Colors.grey;
                          break;
                        default:
                          iconData = Icons.home;
                          iconColor = Colors.red;
                      }

                      selected.add(Select(
                          id: snapshot.data!.docs[index].id,
                          checkValue: false));

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => SandingGroomView(
                                document: document,
                                id: snapshot.data!.docs[index].id,
                              ),
                            ),
                          );
                        },
                        child: ListCard(
                          title: document["title"],
                          duedate: document["duedate"],
                          check: selected[index].checkValue,
                          iconData: iconData,
                          iconColor: iconColor,
                          iconBgColor: Colors.white,
                          onChange: onChange,
                          index: index,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }
}

class Select {
  String id;
  bool checkValue = false;

  Select({required this.id, required this.checkValue});
}
