import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happywedd1/bottomNavBar.dart';

class BudgetItem {
  String id;
  String category;
  String itemName;
  double budget;

  BudgetItem({
    required this.id,
    required this.category,
    required this.itemName,
    required this.budget,
  });
}

class NikahBudget extends StatefulWidget {
  final String userId;

  const NikahBudget({Key? key, required this.userId}) : super(key: key);

  @override
  _NikahBudgetState createState() => _NikahBudgetState();
}

class _NikahBudgetState extends State<NikahBudget> {
  List<BudgetItem> budgetItems = [];
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _budgetController = TextEditingController();
  late FirebaseFirestore _firestore;
  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _loadBudgetItems();
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
              "Sanding Budget",
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
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildBudgetItemList(),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 150,
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
                "Add Budget",
                style: TextStyle(fontSize: 12, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetItemList() {
    List<String> filterCategories = [
      "All",
      "Venue",
      "Vendors",
      "Caterer",
      "Invitation Card",
      "Safety",
      "Others"
    ];

    // Calculate the sum of the budget for the selected category
    double sumOfBudget = 0;
    for (var item in budgetItems) {
      if (selectedFilter == "All" || item.category == selectedFilter) {
        sumOfBudget += item.budget;
      }
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Filter dropdown with box-like appearance
          Container(
            width: 250,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Category:',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 10),
                // Dropdown to filter by categories
                DropdownButton<String>(
                  isDense: true,
                  value: selectedFilter,
                  items: filterCategories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                    });
                  },
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  dropdownColor: Colors.white,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  underline: Container(
                    height: 1.5,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Display the sum of the budget
          Text(
            'Sum of Budget: RM${sumOfBudget.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          // List of budget items based on the selected filter
          Expanded(
            child: ListView.builder(
              itemCount: budgetItems.length,
              itemBuilder: (context, index) {
                // Check if the item should be displayed based on the selected filter
                if (selectedFilter == "All" ||
                    budgetItems[index].category == selectedFilter) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            budgetItems[index].itemName,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Budget: RM${budgetItems[index].budget.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteBudgetItem(budgetItems[index].id);
                        },
                      ),
                    ),
                  );
                } else {
                  // Return an empty container for items that should be filtered out
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    _itemNameController.clear();
    _budgetController.clear();

    List<String> categories = [
      "Venue",
      "Vendors",
      "Caterer",
      "Invitation Card",
      "Safety",
      "Others",
    ];

    // Initialize the selected category
    String selectedCategory = categories[0];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add New Budget Item',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.purple[50],
          content: SingleChildScrollView(
            child: Container(
              width: 100,
              height: 250, // Adjust the height as needed
              child: Column(
                children: [
                  SizedBox(
                    width: 150,
                    height: 70,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true, // Set isExpanded to true
                      value: selectedCategory,
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Category',
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
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        filled:
                            true, // Set to true to enable filling the background
                        fillColor: Colors.white,
                      ),
                      // Set a fixed width for the dropdown button
                      isDense: true,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight:
                              FontWeight.w500), // Set text color when closed
                      dropdownColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    height: 70,
                    child: TextFormField(
                      controller: _itemNameController,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Item Name',
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
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    height: 70,
                    child: TextFormField(
                      controller: _budgetController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Budget (RM)',
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
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                await _saveBudgetItem(selectedCategory);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _loadBudgetItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> budgetQuery = await _firestore
          .collection("users")
          .doc(widget.userId)
          .collection("nikahBudget")
          .get();

      setState(() {
        budgetItems = budgetQuery.docs.map((doc) {
          var data = doc.data();
          return BudgetItem(
            id: doc.id,
            category: data["category"],
            itemName: data["itemName"],
            budget: data["budget"].toDouble(),
          );
        }).toList();
      });
    } catch (e) {
      print("Error loading Budget Items: $e");
    }
  }

  Future<void> _saveBudgetItem(String category) async {
    try {
      CollectionReference<Map<String, dynamic>> budgetCollection = _firestore
          .collection("users")
          .doc(widget.userId)
          .collection("nikahBudget");

      await budgetCollection.add({
        "category": category,
        "itemName": _itemNameController.text,
        "budget": double.parse(_budgetController.text),
      });

      setState(() {
        _itemNameController.clear();
        _budgetController.clear();
      });

      _loadBudgetItems();
    } catch (e) {
      print("Error saving Budget Item: $e");
    }
  }

  Future<void> _deleteBudgetItem(String itemId) async {
    try {
      await _firestore
          .collection("users")
          .doc(widget.userId)
          .collection("nikahBudget")
          .doc(itemId)
          .delete();

      _loadBudgetItems();
    } catch (e) {
      print("Error deleting Budget Item: $e");
    }
  }
}
