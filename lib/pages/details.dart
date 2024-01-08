import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happywedd1/appBar.dart';
import 'package:happywedd1/pages/GreetScreen.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Fill In Your Details"),
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
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 20),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _dateNikah = pickedDate;
                        _dateNikahController.text =
                            "${_dateNikah!.day}/${_dateNikah!.month}/${_dateNikah!.year}";
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
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 20),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _dateSandingBride = pickedDate;
                        _dateSandingBrideController.text =
                            "${_dateSandingBride!.day}/${_dateSandingBride!.month}/${_dateSandingBride!.year}";
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
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 20),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _dateSandingGroom = pickedDate;
                        _dateSandingGroomController.text =
                            "${_dateSandingGroom!.day}/${_dateSandingGroom!.month}/${_dateSandingGroom!.year}";
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
                      MaterialPageRoute(builder: (builder) => GreetScreen()),
                      (route) => false,
                    );
                  },
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
