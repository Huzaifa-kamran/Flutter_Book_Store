import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
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


// methods

// method 1

 Future uploadFile() async {
    try {
      if (pickedfile == null || pickedfile!.bytes == null) {
        // Handle the case when no file is picked or the bytes are null
        return;
      }
      final path = 'books/${pickedfile!.name}';
      final ref = FirebaseStorage.instance.ref().child(path);
      print(path);
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
      'imageUrl': urlDownload, // Add image URL to Firestore
    })
    .then((value)=>  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Book add successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2))))
    .catchError((error)=>  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error while adding the book ' + error.message),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2))));
      print("URL Link ${urlDownload}");
      setState(() {
        uploadTask = null;
      });
    } on FirebaseException catch (ex) {
      print(ex.code.toString());
    }
  }


// method 2 


  Future SelectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final platformFile = result.files.first;
    bytes = platformFile.bytes;
    setState(() {
      pickedfile = result.files.first;
    });
  }

// methods
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
            onTap: SelectFile,
            child: bytes != null ? Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.memory(
                                bytes!, // Fallback to empty string if imageUrl is null
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ) : Container(
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
           
            //------------------------------------Preview of picked file
            



            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
            SizedBox(height: 20),
                        TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Book Price',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
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
                onPressed: () {
                  uploadFile();
                },
                style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                    backgroundColor: Colors.black),
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

      //       Column(
      //   children: [

      //     Expanded(
      //       child: StreamBuilder<QuerySnapshot>(
      //         stream:
      //             FirebaseFirestore.instance.collection('Books').snapshots(),
      //         builder: (context, snapshot) {
      //           if (!snapshot.hasData) {
      //             return const Center(child: CircularProgressIndicator());
      //           }

      //           final books = snapshot.data!.docs;

      //           return ListView.builder(
      //             itemCount: books.length,
      //             itemBuilder: (context, index) {
      //               final book = books[index];

      //               return ListTile(
      //                 title: Text(book['title']),
      //                 subtitle: Text('Author: ${book['author']}'),
      //                 trailing: Row(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: [
      //                     IconButton(
      //                       icon: const Icon(Icons.edit),
      //                       onPressed: () {
      //                         _titleController.text = book['title'];
      //                         _authorController.text = book['author'];
      //                         _priceController.text = book['price'].toString();

      //                         showDialog(
      //                           context: context,
      //                           builder: (context) => AlertDialog(
      //                             title: const Text('Update Book'),
      //                             content: Column(
      //                               mainAxisSize: MainAxisSize.min,
      //                               children: [
      //                                 TextField(
      //                                   controller: _titleController,
      //                                   decoration: const InputDecoration(
      //                                     labelText: 'Title',
      //                                   ),
      //                                 ),
      //                                 TextField(
      //                                   controller: _authorController,
      //                                   decoration: const InputDecoration(
      //                                     labelText: 'Author',
      //                                   ),
      //                                 ),
      //                                 TextField(
      //                                   controller: _priceController,
      //                                   decoration: const InputDecoration(
      //                                     labelText: 'Price',
      //                                   ),
      //                                   keyboardType: TextInputType.number,
      //                                 ),
      //                               ],
      //                             ),
      //                             actions: [
      //                               ElevatedButton(
      //                                 onPressed: () {
      //                                   _updateBook(book.id);
      //                                   Navigator.of(context).pop();
      //                                 },
      //                                 child: const Text('Update'),
      //                               ),
      //                             ],
      //                           ),
      //                         );
      //                       },
      //                     ),
      //                     IconButton(
      //                       icon: const Icon(Icons.delete),
      //                       onPressed: () => _removeBook(book.id),
      //                     ),
      //                   ],
      //                 ),
      //               );
      //             },
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
