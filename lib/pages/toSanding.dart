import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happywedd1/pages/listCard.dart';
import 'package:happywedd1/pages/toSandingAdd.dart';
import 'package:happywedd1/pages/toSandingView.dart';
import 'package:happywedd1/services/auth.dart';

class ToSanding extends StatefulWidget {
  ToSanding({super.key});

  @override
  _ToSandingState createState() => _ToSandingState();
}

class _ToSandingState extends State<ToSanding> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("toSanding").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text(
            "To Sanding",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/google.svg"),
            ),
            SizedBox(
              width: 25,
            ),
          ],
          bottom: PreferredSize(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text(
                  "Monday 21",
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(35),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black87,
          items: [
            BottomNavigationBarItem(
              label: 'Some String',
              icon: Icon(
                Icons.home,
                size: 32,
                color: Colors.white,
              ),
            ),
            BottomNavigationBarItem(
                label: 'Some String',
                icon: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ToSandingAdd()));
                  },
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          Colors.indigoAccent,
                          Colors.purple,
                        ])),
                    child: Icon(
                      Icons.add,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                )),
            BottomNavigationBarItem(
              label: 'Some String',
              icon: Icon(
                Icons.settings,
                size: 32,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: _stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  IconData iconData;
                  Color iconColor;
                  Map<String, dynamic> document =
                      snapshot.data?.docs[index].data() as Map<String, dynamic>;
                  switch (document["category"]) {
                    case "Venue":
                      iconData = Icons.home;
                      iconColor = Colors.blue;
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
                      iconColor = Colors.purple;
                      break;
                    case "Precautionary Measures":
                      iconData = Icons.healing;
                      iconColor = Colors.amber;
                      break;
                    default:
                      iconData = Icons.home;
                      iconColor = Colors.red;
                  }

                  // ToSandingView toSandingView =
                  //     ToSandingView(document: document);

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => ToSandingView(
                                    document: document,
                                    id: snapshot.data!.docs[index].id,
                                  )));
                    },
                    child: ListCard(
                      title: document["title"],
                      time: "10 AM",
                      check: true,
                      iconData: iconData,
                      iconColor: iconColor,
                      iconBgColor: Colors.white,
                    ),
                  );
                },
              );

              // child: Container(
              //     height: MediaQuery.of(context).size.height,
              //     width: MediaQuery.of(context).size.width,
              //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              //     child: Column(
            }));
  }
}
