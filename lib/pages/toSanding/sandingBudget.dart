import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sanding Budget"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Sanding Budget',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildCategoryDropdown(),
            SizedBox(height: 10),
            _buildBudgetItemList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: budgetItems.isEmpty ? null : budgetItems.first.category,
      items: budgetItems.map((item) {
        return DropdownMenuItem<String>(
          value: item.category,
          child: Text(item.category),
        );
      }).toList(),
      onChanged: (value) {
        // Handle category change
      },
      decoration: InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(),
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
                    'Budget: \$${budgetItems[index].budget.toStringAsFixed(2)}',
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
            height: 200,
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
              onPressed: () {
                _saveBudgetItem();
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _saveBudgetItem() {
    // Add your logic to save the budget item
    // For example, add it to the budgetItems list
    setState(() {
      budgetItems.add(
        BudgetItem(
          id: DateTime.now().toString(),
          category: _categoryController.text,
          itemName: _itemNameController.text,
          budget: double.parse(_budgetController.text),
        ),
      );
    });
  }

  void _deleteBudgetItem(String itemId) {
    // Add your logic to delete the budget item
    setState(() {
      budgetItems.removeWhere((item) => item.id == itemId);
    });
  }
}
