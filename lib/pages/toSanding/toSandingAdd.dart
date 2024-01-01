import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happywedd1/pages/toSanding/toSanding.dart';

class ToSandingAdd extends StatefulWidget {
  ToSandingAdd({super.key});

  @override
  _ToSandingAddState createState() => _ToSandingAddState();
}

class _ToSandingAddState extends State<ToSandingAdd> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  String target = "";
  String category = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff1d1e26),
            Color(0xff252041),
          ]),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.arrow_left,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "To Sanding",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Checklist",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label("Task Title"),
                    SizedBox(
                      height: 12,
                    ),
                    title(),
                    SizedBox(
                      height: 30,
                    ),
                    label("Notes"),
                    SizedBox(
                      height: 12,
                    ),
                    notes(),
                    SizedBox(
                      height: 30,
                    ),
                    label("For"),
                    SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      children: [
                        targetChip("Groom", 0xffff6d6e),
                        SizedBox(
                          width: 20,
                        ),
                        targetChip("Bride", 0xffff6d6e),
                        SizedBox(
                          width: 20,
                        ),
                        targetChip("Both", 0xffff6d6e),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    label("Category"),
                    SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        categoryChip("Venue", 0xffff6d6e),
                        SizedBox(
                          width: 20,
                        ),
                        categoryChip("Caterer", 0xffff6d6e),
                        SizedBox(
                          width: 20,
                        ),
                        categoryChip("Vendors", 0xffff6d6e),
                        SizedBox(
                          width: 20,
                        ),
                        categoryChip("Guest List", 0xffff6d6e),
                        SizedBox(
                          width: 20,
                        ),
                        categoryChip("Invitation Card", 0xffff6d6e),
                        SizedBox(
                          width: 20,
                        ),
                        categoryChip("Precautionary Measures", 0xffff6d6e),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    submitBtn(),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitBtn() {
    return InkWell(
      onTap: () async {
        // Get the current user's ID
        String userId =
            FirebaseAuth.instance.currentUser?.uid ?? "default_user_id";

        // Store data in the "users/tosanding" subcollection
        FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("tosanding")
            .add({
          "title": _titleController.text,
          "notes": _notesController.text,
          "target": target,
          "category": category
        });

        Navigator.pop(context);
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: RadialGradient(colors: [
            Colors.lightBlue,
            Colors.lightGreen,
          ]),
        ),
        child: Center(
          child: Text(
            "Add Todo",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget notes() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _notesController,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget targetChip(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          target = label;
        });
      },
      child: Chip(
        backgroundColor: target == label ? Colors.white : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: target == label ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }

  Widget categoryChip(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          category = label;
        });
      },
      child: Chip(
        backgroundColor: category == label ? Colors.white : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: category == label ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16.5,
        letterSpacing: 0.2,
      ),
    );
  }
}
