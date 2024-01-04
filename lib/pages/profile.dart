import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happywedd1/bottomNavBar.dart';
import 'package:happywedd1/pages/splashScreen.dart';
import 'package:happywedd1/services/auth.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthClass authClass = AuthClass();
  TextEditingController _nameBrideController = TextEditingController();
  TextEditingController _nameGroomController = TextEditingController();
  TextEditingController _nikahDateController = TextEditingController();
  TextEditingController _sandingDateController = TextEditingController();
  late String userId;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;

  _ProfileState() {
    userId = FirebaseAuth.instance.currentUser?.uid ?? "default_user_id";
    _stream =
        FirebaseFirestore.instance.collection("users").doc(userId).snapshots();
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
              "Profile",
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
            color: Colors.white,
            onPressed: () async {
              await authClass.logOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => const SplashScreen()),
                (route) => false,
              );
            },
          ),
        ],
        centerTitle: true,
        toolbarHeight: 80,
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildUserDataSection(),
              // Add other sections as needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDataSection() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var userData = snapshot.data!.data();

          String brideName = userData?['nameBride'] ?? 'Bride';
          String groomName = userData?['nameGroom'] ?? 'Groom';
          String nikahDate = userData?['nikahDate'] != null
              ? (userData?['nikahDate'] as Timestamp).toDate().toString()
              : 'Nikah Date';

          String sandingDate = userData?['sandingDate'] != null
              ? (userData?['sandingDate'] as Timestamp).toDate().toString()
              : 'Sanding Date';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userData?['email'] ?? 'User',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 53, 41, 95),
                  ),
                ),
                SizedBox(height: 10),
                Text('Bride\'s Name: $brideName'),
                SizedBox(height: 10),
                Text('Groom\'s Name: $groomName'),
                SizedBox(height: 10),
                Text('Nikah Date: $nikahDate'),
                SizedBox(height: 10),
                Text('Sanding Date: $sandingDate'),
                SizedBox(height: 20),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // Function to format Firestore timestamp to a string
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp != null) {
      // Use your preferred date format here
      var date = timestamp.toDate();
      return "${date.day}/${date.month}/${date.year}";
    }
    return '';
  }
}
