import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happywedd1/pages/toSanding.dart';

class ToSandingView extends StatefulWidget {
  final Map<String, dynamic> document;
  final String id;

  ToSandingView({super.key, required this.document, required this.id});

  @override
  _ToSandingViewState createState() => _ToSandingViewState();
}

class _ToSandingViewState extends State<ToSandingView> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  String target = "";
  String category = "";
  bool edit = false;

  @override
  void initState() {
    super.initState();
    String title = widget.document["title"] ?? "Hey there";
    _titleController = TextEditingController(text: title);
    _notesController = TextEditingController(text: widget.document["notes"]);
    target = widget.document["target"];
    category = widget.document["category"];
  }

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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            CupertinoIcons.arrow_left,
                            color: Colors.white,
                            size: 28,
                          )),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              edit = !edit;
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: edit ? Colors.red : Colors.white,
                            size: 28,
                          )),
                    ]),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        edit ? "Editing" : "To Sanding",
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
                      // SizedBox(
                      //   height: 8,
                      // ),
                      // Text(
                      //   "Task Title",
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.w600,
                      //     letterSpacing: 4,
                      //   ),
                      // ),
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
                      edit ? submitBtn() : Container(),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ))));
  }

  Widget submitBtn() {
    return InkWell(
        onTap: () {
          FirebaseFirestore.instance
              .collection("toSanding")
              .doc(widget.id)
              .update({
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
                ])),
            child: Center(
                child: Text("Update Todo",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )))));
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
        enabled: edit,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Tast Title",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            )),
      ),
    );
  }

  Widget targetChip(String label, int color) {
    return InkWell(
        onTap: edit
            ? () {
                setState(() {
                  target = label;
                });
              }
            : null,
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
        ));
  }

  Widget categoryChip(String label, int color) {
    return InkWell(
        onTap: edit
            ? () {
                setState(() {
                  category = label;
                });
              }
            : null,
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
        ));
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
        enabled: edit,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Tast Title",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            )),
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
