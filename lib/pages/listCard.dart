import 'package:flutter/material.dart';

class ListCard extends StatefulWidget {
  final String title;
  final String time;
  final bool check;
  final IconData iconData;
  final Color iconColor;
  final Color iconBgColor;

  const ListCard({
    super.key,
    required this.title,
    required this.time,
    required this.check,
    required this.iconData,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  // late final String initTitle;

  // @override
  // void initState() {
  //   super.initState();
  //   initTitle = widget.title;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Row(children: [
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
                onChanged: (bool? value) {},
              ),
            ),
            data: ThemeData(
              primarySwatch: Colors.blue,
              unselectedWidgetColor: Color(0xff5e616a),
            ),
          ),
          Expanded(
              child: Container(
                  height: 75,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Color(0xff2a2e3d),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 33,
                            width: 36,
                            decoration: BoxDecoration(
                              color: widget.iconBgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                Icon(widget.iconData, color: widget.iconColor),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Text(widget.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ))),
                          Text(
                            widget.time,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ))))
        ]));
  }
}