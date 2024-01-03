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
  List<BudgetItem> filteredBudgetItems = [];
  TextEditingController _categoryController =
      TextEditingController(text: "All");
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _budgetController = TextEditingController();
  late FirebaseFirestore _firestore;

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
                "Nikah Budget",
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
              _buildCategoryDropdown(),
              SizedBox(height: 10),
              _buildBudgetItemList(),
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
                        "Add Budget",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      )
                    ]))));
  }

  Widget _buildCategoryDropdown() {
    List<String> categoryList =
        budgetItems.map((item) => item.category).toSet().toList();
    categoryList.insert(0, "All");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _categoryController.text,
          items: categoryList.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _categoryController.text = value!;
              _filterBudgetItemsByCategory(value);
            });
          },
          decoration: InputDecoration(
            labelText: 'Select Category',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            'Sum of Budget: RM${_getSumOfBudgetInCategory(_categoryController.text).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetItemList() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredBudgetItems.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filteredBudgetItems[index].itemName,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Budget: RM${filteredBudgetItems[index].budget.toStringAsFixed(2)}',
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteBudgetItem(filteredBudgetItems[index].id);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _filterBudgetItemsByCategory(String category) {
    setState(() {
      if (category == "All") {
        filteredBudgetItems = budgetItems;
      } else {
        filteredBudgetItems =
            budgetItems.where((item) => item.category == category).toList();
      }
    });
  }

  double _getSumOfBudgetInCategory(String category) {
    return budgetItems
        .where((item) => category == "All" || item.category == category)
        .fold(0, (sum, item) => sum + item.budget);
  }

  void _showAddItemDialog() {
    _categoryController.clear();
    _itemNameController.clear();
    _budgetController.clear();

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
          content: Container(
            height: 250, // Adjust the height as needed
            child: Column(
              children: [
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Budget',
                  ),
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
                await _saveBudgetItem(); // Save data to Firestore
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
          .collection("nikahbudget")
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

        // Show all items by default when "All" category is selected
        _filterBudgetItemsByCategory(_categoryController.text);
      });
    } catch (e) {
      print("Error loading Budget Items: $e");
    }
  }

  Future<void> _saveBudgetItem() async {
    try {
      CollectionReference<Map<String, dynamic>> budgetCollection = _firestore
          .collection("users")
          .doc(widget.userId)
          .collection("nikahbudget");

      await budgetCollection.add({
        "category": _categoryController.text,
        "itemName": _itemNameController.text,
        "budget": double.parse(_budgetController.text),
      });

      setState(() {
        _categoryController.clear();
        _itemNameController.clear();
        _budgetController.clear();
      });

      _loadBudgetItems(); // Reload budget items after save
    } catch (e) {
      print("Error saving Budget Item: $e");
    }
  }

  Future<void> _deleteBudgetItem(String itemId) async {
    try {
      await _firestore
          .collection("users")
          .doc(widget.userId)
          .collection("nikahbudget")
          .doc(itemId)
          .delete();

      _loadBudgetItems(); // Reload budget items after delete
    } catch (e) {
      print("Error deleting Budget Item: $e");
    }
  }
}
