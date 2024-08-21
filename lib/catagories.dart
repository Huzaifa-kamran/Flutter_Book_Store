import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageCategories extends StatefulWidget {
  const ManageCategories({super.key});

  @override
  _ManageCategoriesState createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories> {
  final TextEditingController _categoryController = TextEditingController();
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _addCategory() async {
    final categoryName = _categoryController.text.trim();
    if (categoryName.isNotEmpty) {
      try {
        await _categoriesCollection.add({'name': categoryName});
        _categoryController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add category: $e')),
        );
      }
    }
  }

  void _updateCategory(String id, String newName) async {
    final trimmedName = newName.trim();
    if (trimmedName.isNotEmpty) {
      try {
        await _categoriesCollection.doc(id).update({'name': trimmedName});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update category: $e')),
        );
      }
    }
  }

  void _deleteCategory(String id) async {
    try {
      await _categoriesCollection.doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete category: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCategory,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _categoriesCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No categories found'));
                }
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final category = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(category['name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditDialog(doc.id, category['name']);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteCategory(doc.id);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String id, String currentName) {
    final TextEditingController _editController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: TextField(
            controller: _editController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateCategory(id, _editController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
