import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happywedd1/bottomNavBar.dart';
import 'package:happywedd1/pages/profile.dart';
import 'package:intl/intl.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameBrideController = TextEditingController();
  TextEditingController _nameGroomController = TextEditingController();
  TextEditingController _dateNikahController = TextEditingController();
  TextEditingController _dateSandingBrideController = TextEditingController();
  TextEditingController _dateSandingGroomController = TextEditingController();

  DateTime? _dateNikah;
  DateTime? _dateSandingBride;
  DateTime? _dateSandingGroom;

  @override
  void initState() {
    super.initState();
    // Fetch existing data from Firestore and set it in the controllers
    _fetchExistingData();
  }

  // Fetch existing data from Firestore and set it in the controllers
  void _fetchExistingData() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "default_user_id";
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();

    if (snapshot.exists) {
      var userData = snapshot.data();

      setState(() {
        _nameBrideController.text = userData?['nameBride'] ?? '';
        _nameGroomController.text = userData?['nameGroom'] ?? '';
        _dateNikahController.text =
            _formatTimestamp(userData?['dateNikah']?.toDate());
        _dateSandingBrideController.text =
            _formatTimestamp(userData?['dateSandingBride']?.toDate());
        _dateSandingGroomController.text =
            _formatTimestamp(userData?['dateSandingGroom']?.toDate());

        // Set DateTime values for date pickers
        _dateNikah = userData?['dateNikah']?.toDate();
        _dateSandingBride = userData?['dateSandingBride']?.toDate();
        _dateSandingGroom = userData?['dateSandingGroom']?.toDate();
      });
    }
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
              "Sanding Itinerary",
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
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameBrideController,
                  decoration: InputDecoration(
                    labelText: 'Name of the Bride',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the bride\'s name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _nameGroomController,
                  decoration: InputDecoration(
                    labelText: 'Name of the Groom',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the groom\'s name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _dateNikahController,
                  decoration: InputDecoration(
                    labelText: 'Nikah Date',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _dateNikah ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 20),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _dateNikah = pickedDate;
                        _dateNikahController.text =
                            _formatTimestamp(pickedDate);
                      });
                    }
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _dateSandingBrideController,
                  decoration: InputDecoration(
                    labelText: 'Bride Sanding Date',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _dateSandingBride ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 20),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _dateSandingBride = pickedDate;
                        _dateSandingBrideController.text =
                            _formatTimestamp(pickedDate);
                      });
                    }
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _dateSandingGroomController,
                  decoration: InputDecoration(
                    labelText: 'Groom Sanding Date',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _dateSandingGroom ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 20),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _dateSandingGroom = pickedDate;
                        _dateSandingGroomController.text =
                            _formatTimestamp(pickedDate);
                      });
                    }
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    // Get the current user's ID
                    String userId = FirebaseAuth.instance.currentUser?.uid ??
                        "default_user_id";

                    // Convert DateTime to Timestamp for Firestore
                    Timestamp nikahTimestamp = _dateNikah != null
                        ? Timestamp.fromDate(_dateNikah!)
                        : Timestamp.now();

                    Timestamp bridesandingTimestamp = _dateSandingBride != null
                        ? Timestamp.fromDate(_dateSandingBride!)
                        : Timestamp.now();

                    Timestamp groomsandingTimestamp = _dateSandingGroom != null
                        ? Timestamp.fromDate(_dateSandingGroom!)
                        : Timestamp.now();

                    // Store data directly in the "users" collection
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(userId)
                        .set({
                      "nameBride": _nameBrideController.text,
                      "nameGroom": _nameGroomController.text,
                      "dateNikah": nikahTimestamp,
                      "dateSandingBride": bridesandingTimestamp,
                      "dateSandingGroom": groomsandingTimestamp,
                      // Add more fields as needed
                    }, SetOptions(merge: true));

                    // Navigate to HomePage and remove all previous routes
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => Profile()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple, // Set button color
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white, // Set text color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Format timestamp to a readable string
  String _formatTimestamp(DateTime? date) {
    return date != null
        ? DateFormat('EEEE, dd MMM yyyy').format(date)
        : "Select Date";
  }
}
