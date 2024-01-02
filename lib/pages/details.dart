import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:happywedd1/pages/home.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameBrideController = TextEditingController();
  TextEditingController _nameGroomController = TextEditingController();
  TextEditingController _nikahDateController = TextEditingController();
  TextEditingController _sandingDateController = TextEditingController();

  DateTime? _nikahDate;
  DateTime? _sandingDate;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
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
                  controller: _nikahDateController,
                  decoration: InputDecoration(
                    labelText: 'Nikah Date',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _nikahDate = pickedDate;
                        _nikahDateController.text =
                            "${_nikahDate!.day}/${_nikahDate!.month}/${_nikahDate!.year}";
                      });
                    }
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _sandingDateController,
                  decoration: InputDecoration(
                    labelText: 'Sanding Date',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _sandingDate = pickedDate;
                        _sandingDateController.text =
                            "${_sandingDate!.day}/${_sandingDate!.month}/${_sandingDate!.year}";
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
                    Timestamp nikahTimestamp = _nikahDate != null
                        ? Timestamp.fromDate(_nikahDate!)
                        : Timestamp.now();

                    Timestamp sandingTimestamp = _sandingDate != null
                        ? Timestamp.fromDate(_sandingDate!)
                        : Timestamp.now();

                    // Store data directly in the "users" collection
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(userId)
                        .set({
                      "nameBride": _nameBrideController.text,
                      "nameGroom": _nameGroomController.text,
                      "nikahDate": nikahTimestamp,
                      "sandingDate": sandingTimestamp,
                      // Add more fields as needed
                    }, SetOptions(merge: true));

                    // Navigate to HomePage and remove all previous routes
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => HomePage()),
                      (route) => false,
                    );
                  },
                  child: Text('Submit'),
                ),
                SizedBox(height: 20.0),
                Column(
                  children: [
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        // Handle map-related action if needed
                      },
                      child: Text('Custom Map Action'),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 300.0,
                      child: GoogleMap(
                        // onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _selectedLocation!,
                          zoom: 15.0,
                        ),
                        onTap: (LatLng latLng) {
                          // Handle map tap events if needed
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
