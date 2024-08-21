import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class ManageBooks extends StatefulWidget {
  const ManageBooks({super.key});

  @override
  _ManageBooksState createState() => _ManageBooksState();
}

class _ManageBooksState extends State<ManageBooks> {
  PlatformFile? pickedfile;
  Uint8List? bytes;
  UploadTask? uploadTask;

  String? _selectedCategory;
  List<String> _categories = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        _categories =
            snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> uploadFile() async {
    try {
      if (pickedfile == null || pickedfile!.bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select an image file'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
        return;
      }
      final path = 'books/${pickedfile!.name}';
      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        uploadTask = ref.putData(pickedfile!.bytes!);
      });

      final snapshot = await uploadTask!.whenComplete(() => {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('Books').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'author': _authorController.text,
        'price': double.parse(_priceController.text),
        'category': _selectedCategory,
        'imageUrl': urlDownload,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Book added successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ));
      setState(() {
        uploadTask = null;
      });
    } on FirebaseException catch (ex) {
      print(ex.code.toString());
    }
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final platformFile = result.files.first;
    bytes = platformFile.bytes;
    setState(() {
      pickedfile = result.files.first;
    });
  }

  Future<void> updateBook(String bookId) async {
    try {
      final path = pickedfile != null ? 'books/${pickedfile!.name}' : null;
      String? urlDownload;

      if (path != null) {
        final ref = FirebaseStorage.instance.ref().child(path);
        setState(() {
          uploadTask = ref.putData(pickedfile!.bytes!);
        });

        final snapshot = await uploadTask!.whenComplete(() => {});
        urlDownload = await snapshot.ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('Books').doc(bookId).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'author': _authorController.text,
        'price': double.parse(_priceController.text),
        'category': _selectedCategory,
        if (urlDownload != null) 'imageUrl': urlDownload,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Book updated successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ));
      setState(() {
        uploadTask = null;
      });
    } on FirebaseException catch (ex) {
      print(ex.code.toString());
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await FirebaseFirestore.instance.collection('Books').doc(bookId).delete();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Book deleted successfully'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      print("Error deleting book: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting book'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  }

  void showBookListDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book List'),
        content: Container(
          width: double.maxFinite,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Books').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final books = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final bookData = books[index].data() as Map<String, dynamic>;
                  final bookId = books[index].id;

                  return ListTile(
                    title: Text(bookData['title'] ?? 'No Title'),
                    subtitle: Text(bookData['author'] ?? 'No Author'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            showUpdateBookDialog(bookData, bookId);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteBook(bookId);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void showUpdateBookDialog(Map<String, dynamic> bookData, String bookId) {
    _titleController.text = bookData['title'] ?? '';
    _descriptionController.text = bookData['description'] ?? '';
    _authorController.text = bookData['author'] ?? '';
    _priceController.text = bookData['price']?.toString() ?? '';
    _selectedCategory = bookData['category'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Book'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: selectFile,
                child: bytes != null
                    ? Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            bytes!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Image.network(
                        bookData['imageUrl'] ?? '',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 20),
              _buildTextField(_titleController, 'Book Title'),
              SizedBox(height: 20),
              _buildTextField(_descriptionController, 'Description'),
              SizedBox(height: 20),
              _buildTextField(_authorController, 'Author'),
              SizedBox(height: 20),
              _buildTextField(_priceController, 'Book Price',
                  keyboardType: TextInputType.number),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              updateBook(bookId);
              Navigator.of(context).pop();
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Books'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload image of book here",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: selectFile,
                child: bytes != null
                    ? Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            bytes!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[700],
                            size: 50,
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(_titleController, 'Book Title'),
            SizedBox(height: 20),
            _buildTextField(_descriptionController, 'Description'),
            SizedBox(height: 20),
            _buildTextField(_authorController, 'Author'),
            SizedBox(height: 20),
            _buildTextField(_priceController, 'Book Price',
                keyboardType: TextInputType.number),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: uploadFile,
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    backgroundColor: Colors.black),
                child: const Text(
                  'Add Book',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: showBookListDialog,
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    backgroundColor: Colors.black),
                child: const Text(
                  'Book List',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
