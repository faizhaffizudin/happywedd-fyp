import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListCard extends StatefulWidget {
  final String title;
  final Timestamp? duedate; // Assuming Timestamp is the correct type
  final bool check;
  final IconData iconData;
  final Color iconColor;
  final Color iconBgColor;
  final Function onChange;
  final int index;

  const ListCard({
    Key? key,
    required this.title,
    required this.duedate,
    required this.check,
    required this.iconData,
    required this.iconColor,
    required this.iconBgColor,
    required this.onChange,
    required this.index,
  });

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                activeColor: Color(0xff6cf8a9),
                checkColor: Color(0xff0e3e26),
                value: widget.check,
                onChanged: (bool? value) {
                  widget.onChange(widget.index);
                },
              ),
            ),
            data: ThemeData(
              primarySwatch: Colors.blue,
              unselectedWidgetColor: Color(0xff5e616a),
            ),
          ),
          Flexible(
            child: Container(
              height: 75,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Color.fromARGB(255, 53, 41, 95),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: widget.iconBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(widget.iconData, color: widget.iconColor),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.duedate != null)
                            Text(
                              widget.duedate != null
                                  ? "Due: " +
                                      DateFormat('EEE, d MMM yyyy hh:mm')
                                          .format(widget.duedate!.toDate())
                                  : "No Due Date",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          if (widget.duedate == null)
                            Text(
                              "No Due Date",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
