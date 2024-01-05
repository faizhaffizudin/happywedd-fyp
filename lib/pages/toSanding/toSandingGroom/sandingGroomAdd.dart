import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happywedd1/pages/toSanding/sandingSuggestedTitles.dart';
import 'package:intl/intl.dart';

class SandingGroomAdd extends StatefulWidget {
  SandingGroomAdd({Key? key}) : super(key: key);

  @override
  _SandingGroomAddState createState() => _SandingGroomAddState();
}

class _SandingGroomAddState extends State<SandingGroomAdd> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  String target = "";
  String category = "";
  DateTime? dueDate;
  List<String> suggestedTitles = SandingSuggestedTitles.suggestedTitles;
  String? selectedSuggestedTitles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7F4EFF),
              Color(0xFF5D37F7),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(CupertinoIcons.arrow_left,
                    color: Colors.white, size: 28),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var title in ["Adding", "To Sanding", "Checklist"])
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 33,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    SizedBox(height: 30),
                    buildTitleSection(),
                    SizedBox(height: 12),
                    title(),
                    SizedBox(height: 30),
                    buildDueDateSection(),
                    SizedBox(height: 30),
                    label("Notes"),
                    SizedBox(height: 12),
                    notes(),
                    SizedBox(height: 30),
                    label("For"),
                    SizedBox(height: 12),
                    buildTargetChips(),
                    SizedBox(height: 30),
                    label("Category"),
                    SizedBox(height: 12),
                    buildCategoryChips(),
                    SizedBox(height: 50),
                    submitBtn(),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label("Task Title"),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              TextButton(
                onPressed: _showSuggestedTitlesDialog,
                child: Row(
                  children: [
                    Icon(Icons.format_list_bulleted, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Suggested Task",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDueDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label("Due Date"),
        SizedBox(height: 12),
        dueDateInput(),
      ],
    );
  }

  Widget buildTargetChips() {
    return Wrap(
      runSpacing: 10,
      spacing: 10, // Add spacing between items
      children: [
        for (var targetLabel in ["Bride", "Groom", "Both"])
          targetChip(
            targetLabel,
            0xFF00008B,
            targetLabel == "Both"
                ? Icons.people
                : targetLabel == "Bride"
                    ? Icons.face_2
                    : Icons.face,
          ),
      ],
    );
  }

  Widget buildCategoryChips() {
    return Wrap(
      runSpacing: 10,
      spacing: 10, // Add spacing between items
      children: [
        for (var categoryLabel in [
          "Venue",
          "Caterer",
          "Vendors",
          "Guest List",
          "Invitation Card",
          "Safety",
          "Others"
        ])
          categoryChip(
              categoryLabel, 0xFF00008B, getIconForCategory(categoryLabel)),
      ],
    );
  }

  IconData getIconForCategory(String categoryLabel) {
    switch (categoryLabel) {
      case "Venue":
        return Icons.home;
      case "Caterer":
        return Icons.restaurant;
      case "Vendors":
        return Icons.fastfood;
      case "Guest List":
        return Icons.groups_2;
      case "Invitation Card":
        return Icons.rsvp;
      case "Safety":
        return Icons.healing;
      case "Others":
        return Icons.category;
      default:
        return Icons.category;
    }
  }

  Widget submitBtn() {
    return InkWell(
      onTap: () async {
        String userId =
            FirebaseAuth.instance.currentUser?.uid ?? "default_user_id";
        FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("sandinggroomList") // CHANGE
            .add({
          "title": _titleController.text,
          "notes": _notesController.text,
          "target": target,
          "category": category,
          "duedate": dueDate,
        });
        Navigator.pop(context);
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.deepPurple,
        ),
        child: Center(
          child: Text(
            "Add Todo",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
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
        color: Color(0xFF2A2E3D),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _notesController,
        style: TextStyle(color: Colors.white, fontSize: 17),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Task Notes",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget targetChip(String label, int color, IconData iconData) {
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
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: target == label ? Colors.black : Colors.white,
            ),
            SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                  fontSize: 15,
                  color: target == label ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      ),
    );
  }

  Widget categoryChip(String label, int color, IconData iconData) {
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
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: category == label ? Colors.black : Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                  fontSize: 15,
                  color: category == label ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      ),
    );
  }

  Widget title() {
    return Column(
      children: [
        Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFF2A2E3D),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _titleController,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Task Title",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSuggestedTitlesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Suggested Titles"),
          backgroundColor: Colors.white,
          children: suggestedTitles.map((title) {
            return SimpleDialogOption(
              onPressed: () {
                setState(() {
                  selectedSuggestedTitles = title;
                  _titleController.text = title;
                });
                Navigator.pop(context);
              },
              child: Text(
                title,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget dueDateInput() {
    return InkWell(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );

        if (selectedDate != null) {
          TimeOfDay? selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (selectedTime != null) {
            setState(() {
              dueDate = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );
            });
          }
        }
      },
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xFF2A2E3D),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  dueDate != null
                      ? "${DateFormat('EEEE, dd MMM yyyy').format(dueDate!)}\n${DateFormat('hh:mm').format(dueDate!)}"
                      : "Select Due Date",
                  style: TextStyle(
                    color: dueDate != null ? Colors.white : Colors.grey[600],
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: Colors.grey,
            ),
            SizedBox(width: 20),
          ],
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
          letterSpacing: 0.2),
    );
  }
}
