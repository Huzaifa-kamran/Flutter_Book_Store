import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
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

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${widget.userEmail}');
      await storageRef.putFile(_imageFile!);
      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  void updateUser() async {
    String userName = nameController.text;
    String userPass = passController.text;
    String userAddress = addressController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl = _imageFile != null ? await _uploadImage() : null;

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userEmail)
          .update({
        'name': userName,
        'password': userPass,
        'address': userAddress,
        'image': imageUrl ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Profile Updated Successfully"),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Update Failed: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile'), centerTitle: true),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                            ? const Icon(Icons.camera_alt,
                                size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                        nameController, "Enter Username", Icons.person),
                    const SizedBox(height: 15),
                    _buildTextField(
                        passController, "Enter Password", Icons.lock,
                        obscureText: true),
                    const SizedBox(height: 15),
                    _buildTextField(
                        addressController, "Enter Address", Icons.home),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(
                            side: BorderSide(color: Colors.black, width: 2.2)),
                      ),
                      onPressed: updateUser,
                      icon: const Icon(Icons.update),
                      label: const Text('Update Profile'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
              color: Color.fromARGB(130, 14, 23, 199), width: 3.0),
        ),
        hintText: hintText,
        suffixIcon: Icon(icon),
      ),
      obscureText: obscureText,
      onFieldSubmitted: (value) => updateUser(),
    );
  }
}
