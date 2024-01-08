import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happywedd1/appBar.dart';
import 'package:happywedd1/bottomNavBar.dart';
import 'package:intl/intl.dart';

class ItineraryItem {
  String id;
  String name;
  TimeOfDay time;

  ItineraryItem({required this.id, required this.name, required this.time});
}

class SandingBrideItinerary extends StatefulWidget {
  final String userId;

  const SandingBrideItinerary({Key? key, required this.userId})
      : super(key: key);

  @override
  _SandingBrideItineraryState createState() => _SandingBrideItineraryState();
}

class _SandingBrideItineraryState extends State<SandingBrideItinerary> {
  late String userId;
  DateTime? dateSandingBride;
  List<ItineraryItem> itineraryItems = [];
  TextEditingController _itemNameController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedItemId = '';

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    _loadDateSandingBride();
    _loadItineraryItems();
  }

  Future<void> _loadDateSandingBride() async {
    try {
      // Fetch the date from the "sandingbrideDate" subcollection
      DocumentSnapshot<Map<String, dynamic>> dateSandingBrideDoc =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(widget.userId)
              .get();

      setState(() {
        dateSandingBride = dateSandingBrideDoc["dateSandingBride"]?.toDate();
      });

      if (dateSandingBride != null) {
        String formattedDate =
            DateFormat('EEEE, dd MMM yyyy').format(dateSandingBride!);
        print("Formatted Date: $formattedDate");
      }
    } catch (e) {
      print("Error loading SandingBride Date: $e");
    }
  }

  void _loadItineraryItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> itineraryQuery =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(widget.userId)
              .collection("sandingbrideItinerary")
              .get();

      setState(() {
        itineraryItems = itineraryQuery.docs.map((doc) {
          var data = doc.data();
          return ItineraryItem(
            id: doc.id,
            name: data["name"],
            time: TimeOfDay(
              hour: int.parse(data["time"].split(":")[0]),
              minute: int.parse(data["time"].split(":")[1]),
            ),
          );
        }).toList();

        // Sort the list by time in ascending order
        itineraryItems.sort((a, b) =>
            a.time.hour * 60 +
            a.time.minute -
            (b.time.hour * 60 + b.time.minute));
      });
    } catch (e) {
      print("Error loading Itinerary Items: $e");
    }
  }

  Future<void> _saveItineraryItem() async {
    try {
      CollectionReference<Map<String, dynamic>> itineraryCollection =
          FirebaseFirestore.instance
              .collection("users")
              .doc(widget.userId)
              .collection("sandingbrideItinerary");

      if (_selectedItemId.isEmpty) {
        // Create
        await itineraryCollection.add({
          "name": _itemNameController.text,
          "time": "${_selectedTime.hour}:${_selectedTime.minute}",
        });
      } else {
        // Update
        await itineraryCollection.doc(_selectedItemId).update({
          "name": _itemNameController.text,
          "time": "${_selectedTime.hour}:${_selectedTime.minute}",
        });
        setState(() {
          _selectedItemId = '';
        });
      }

      _itemNameController.clear();
      _selectedTime = TimeOfDay.now();

      _loadItineraryItems(); // Reload itinerary items after save
    } catch (e) {
      print("Error saving Itinerary Item: $e");
    }
  }

  Future<void> _deleteItineraryItem(String itemId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("sandingbrideItinerary")
          .doc(itemId)
          .delete();

      _loadItineraryItems(); // Reload itinerary items after delete
    } catch (e) {
      print("Error deleting Itinerary Item: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 239, 226, 255),
        appBar: CustomAppBar(title: 'Sanding Itinerary'),
        bottomNavigationBar: BottomNavBar(currentIndex: 1),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              dateSandingBride != null
                  ? Container(
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sanding Bride Date',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 77, 0, 110),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              dateSandingBride != null
                                  ? DateFormat('EEEE, dd MMM yyyy')
                                      .format(dateSandingBride!)
                                  : 'N/A',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: itineraryItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3, // Add elevation for a card-like effect
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itineraryItems[index].time.format(context),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              itineraryItems[index].name,
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditItemDialog(itineraryItems[index]);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteItineraryItem(itineraryItems[index].id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
            width: 150, // Adjust the width as needed
            child: FloatingActionButton(
                onPressed: () {
                  _showAddItemDialog();
                },
                backgroundColor: Colors.purple,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        "Add Itinerary",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      )
                    ]))));
  }

  void _showAddItemDialog() {
    _itemNameController.clear();
    _selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Add New Itinerary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 77, 0, 110),
              ),
            ),
          ),
          // backgroundColor: Colors.purple[50],
          content: Container(
            height: 160, // Adjust the height as needed
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 100,
                  child: TextFormField(
                    controller: _itemNameController,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Details',
                      labelStyle: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Colors.amber,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          width: 1.5,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Select Time:  '),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );

                        if (selectedTime != null) {
                          setState(() {
                            _selectedTime = selectedTime;
                          });
                        }
                      },
                      child: Text(
                          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveItineraryItem(); // Save data to Firestore
                Navigator.pop(context);
              },
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(ItineraryItem item) {
    _selectedItemId = item.id;
    _itemNameController.text = item.name;
    _selectedTime = item.time;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Edit Itinerary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 77, 0, 110),
              ),
            ),
          ),
          content: Container(
            height: 160, // Adjust the height as needed
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 100,
                  child: TextFormField(
                    controller: _itemNameController,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Details',
                      labelStyle: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Colors.amber,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          width: 1.5,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Select Time:  '),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );

                        if (selectedTime != null) {
                          setState(() {
                            _selectedTime = selectedTime;
                          });
                        }
                      },
                      child: Text(
                          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveItineraryItem(); // Save data to Firestore
                Navigator.pop(context);
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
