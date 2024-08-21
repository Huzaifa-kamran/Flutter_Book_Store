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
  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Books',
    'Others'
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Upload file to Firebase Storage
  Future<void> uploadFile() async {
    if (pickedfile == null || pickedfile!.bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected.')),
      );
      return;
    }

    try {
      final path = 'files/${pickedfile!.name}';
      final ref = FirebaseStorage.instance.ref().child(path);

      setState(() {
        uploadTask = ref.putData(pickedfile!.bytes!);
      });

      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('Books').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'author': _authorController.text,
        'price': double.parse(_priceController.text),
        'category': _selectedCategory,
        'imageUrl': urlDownload, // Add image URL to Firestore
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book added successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      clearInputs(); // Clear inputs after successful upload
    } on FirebaseException catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${ex.message}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        uploadTask = null;
      });
    }
  }

  // Select file using File Picker
  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final platformFile = result.files.first;
    bytes = platformFile.bytes;

    setState(() {
      pickedfile = platformFile;
    });
  }

  // Clear input fields
  void clearInputs() {
    _titleController.clear();
    _descriptionController.clear();
    _authorController.clear();
    _priceController.clear();
    setState(() {
      pickedfile = null;
      bytes = null;
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Books'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload image of book here",
                style: TextStyle(fontSize: 20),
              ),
              Center(
                child: GestureDetector(
                  onTap: selectFile,
                  child: bytes != null
                      ? Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
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
                            borderRadius: BorderRadius.circular(20),
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
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Book Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
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
                        EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    'Add Book',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
