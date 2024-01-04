import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController _nameBrideController = TextEditingController();
  TextEditingController _nameGroomController = TextEditingController();
  TextEditingController _dateNikahController = TextEditingController();
  TextEditingController _dateSandingBrideController = TextEditingController();
  TextEditingController _dateSandingGroomController = TextEditingController();
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
              // ElevatedButton(
              //   onPressed: () {
              //     _showEditDialog();
              //   },
              //   child: Text("Edit"),
              // ),
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

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Email: " + userData?['email'] ?? 'User',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 53, 41, 95),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Bride\'s Name: $brideName',
                  style:
                      TextStyle(fontSize: 15), // Adjust the font size as needed
                ),
                SizedBox(height: 10),
                Text(
                  'Groom\'s Name: $groomName',
                  style:
                      TextStyle(fontSize: 15), // Adjust the font size as needed
                ),
                SizedBox(height: 10),
                Text(
                  'Nikah Date: $dateNikah',
                  style:
                      TextStyle(fontSize: 15), // Adjust the font size as needed
                ),
                SizedBox(height: 10),
                Text(
                  'Sanding Date: $dateSandingBride',
                  style:
                      TextStyle(fontSize: 15), // Adjust the font size as needed
                ),
                SizedBox(height: 10),
                Text(
                  'Sanding Date: $dateSandingGroom',
                  style:
                      TextStyle(fontSize: 15), // Adjust the font size as needed
                ),
                SizedBox(height: 10),
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

  String _formatTimestamp(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
    // return DateFormat('EEEE, dd MMM yyyy').format(date);
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Column(
            children: [
              TextFormField(
                controller: _nameBrideController,
                decoration: InputDecoration(labelText: 'Bride\'s Name'),
              ),
              TextFormField(
                controller: _nameGroomController,
                decoration: InputDecoration(labelText: 'Groom\'s Name'),
              ),
              TextFormField(
                controller: _dateNikahController,
                decoration: InputDecoration(labelText: 'Nikah Date'),
              ),
              TextFormField(
                controller: _dateSandingBrideController,
                decoration: InputDecoration(labelText: 'Sanding Date'),
              ),
              TextFormField(
                controller: _dateSandingGroomController,
                decoration: InputDecoration(labelText: 'Sanding Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveChanges();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.purple, // Set your desired color here
              ),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges() {
    // Implement the logic to save changes to Firestore
    FirebaseFirestore.instance.collection("users").doc(userId).update({
      'nameBride': _nameBrideController.text,
      'nameGroom': _nameGroomController.text,
      'dateNikah': _dateNikahController.text,
      'dateSandingBride': _dateSandingBrideController.text,
      'dateSandingGroom': _dateSandingGroomController.text,
    });
  }
}
