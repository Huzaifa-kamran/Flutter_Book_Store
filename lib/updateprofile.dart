import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  final String userEmail;
  const UpdateProfile({super.key, required this.userEmail});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userEmail)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        nameController.text = userData['name'] ?? '';
        passController.text = userData['password'] ?? '';
        addressController.text = userData['address'] ?? '';
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : const AssetImage('images/user2.jpg')
                          as ImageProvider,
                  child: _imageFile == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(130, 14, 23, 199),
                      width: 3.0,
                    ),
                  ),
                  hintText: "Enter Username",
                  suffixIcon: const Icon(Icons.person),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(130, 14, 23, 199),
                      width: 3.0,
                    ),
                  ),
                  hintText: "Enter Password",
                  suffixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(130, 14, 23, 199),
                      width: 3.0,
                    ),
                  ),
                  hintText: "Enter Address",
                  suffixIcon: const Icon(Icons.home),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(
                    side: BorderSide(color: Colors.black, width: 2.2),
                  ),
                ),
                onPressed: () {
                  updateUser();
                },
                icon: const Icon(Icons.update),
                label: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateUser() async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    String userName = nameController.text;
    String userPass = passController.text;
    String userAddress = addressController.text;

    await users.doc(widget.userEmail).update({
      'name': userName,
      'password': userPass,
      'address': userAddress,
      'image': _imageFile != null ? _imageFile!.path : null, 
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Updated Successfully"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context); 
    }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Update Failed"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        ));
  }
}
