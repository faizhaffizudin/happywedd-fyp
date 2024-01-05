import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happywedd1/pages/profileEdit.dart';
import 'package:intl/intl.dart';
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
              "Edit Profile",
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
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildUserDataSection(),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the ProfileEdit page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileEdit()),
                    );
                  },
                  child: Text("Edit Your Profile",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
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

          String dateNikah = userData?['dateNikah'] != null
              ? _formatTimestamp((userData?['dateNikah'] as Timestamp).toDate())
              : 'Nikah Date';

          String dateSandingBride = userData?['dateSandingBride'] != null
              ? _formatTimestamp(
                  (userData?['dateSandingBride'] as Timestamp).toDate())
              : 'Bride Sanding Date';

          String dateSandingGroom = userData?['dateSandingGroom'] != null
              ? _formatTimestamp(
                  (userData?['dateSandingGroom'] as Timestamp).toDate())
              : 'Groom Sanding Date';

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding:
                      EdgeInsets.all(10), // Add padding for the rectangular box
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 53, 41, 95), // Background color
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        // TextSpan(text: "Email:\n"),
                        TextSpan(
                          text: userData?['email'] ?? 'User',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              _buildProfileInfo("Name of the Bride", brideName),
              _buildProfileInfo("Name of the Groom", groomName),
              _buildProfileInfo("Nikah Date", dateNikah),
              _buildProfileInfo("Bride Sanding Date", dateSandingBride),
              _buildProfileInfo("Groom Sanding Date", dateSandingGroom),
              SizedBox(height: 30),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 77, 0, 110),
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  String _formatTimestamp(DateTime? date) {
    return DateFormat('EEEE, dd MMM yyyy').format(date!);
  }
}
