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

class SandingBudget extends StatefulWidget {
  final String userId;

  const SandingBudget({Key? key, required this.userId}) : super(key: key);

  @override
  _SandingBudgetState createState() => _SandingBudgetState();
}

class _SandingBudgetState extends State<SandingBudget> {
  List<BudgetItem> budgetItems = [];
  TextEditingController _categoryController = TextEditingController();
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
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
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
    return Expanded(
      child: ListView.builder(
        itemCount: budgetItems.length,
        itemBuilder: (context, index) {
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
        },
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
      "Precautionary Measure",
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
          content: SingleChildScrollView(
            child: Container(
              height: 250, // Adjust the height as needed
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    height: 70,
                    child: DropdownButtonFormField<String>(
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
                      ),
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
          .collection("sandingbudget")
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
          .collection("sandingbudget");

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
          .collection("sandingbudget")
          .doc(itemId)
          .delete();

      _loadBudgetItems();
    } catch (e) {
      print("Error deleting Budget Item: $e");
    }
  }
}
