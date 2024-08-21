import 'dart:ui';
import 'dart:typed_data'; // Needed for Uint8List
import 'package:bookstore/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' as foundation; // For checking platform

// Import platform-specific packages
import 'package:image_picker/image_picker.dart'; // Import only for mobile
import 'dart:html' as html; // Import only for web

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Variable to store the selected image
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker(); // Image Picker instance

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = screenHeight * 0.2;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/BookStore.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            height: containerHeight,
            color: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.4),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.4),
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: containerHeight),
                        const Text(
                          "Signup",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(128, 248, 244, 244),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          "Enter your INFO",
                          style: TextStyle(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(128, 248, 244, 244),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: 300,
                          padding: const EdgeInsets.all(15),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildProfilePicPicker(),
                                const SizedBox(height: 15),
                                _buildTextField(
                                  controller: nameController,
                                  hintText: "Enter Username",
                                  icon: Icons.person,
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter a username'
                                      : null,
                                ),
                                const SizedBox(height: 15),
                                _buildTextField(
                                  controller: emailController,
                                  hintText: "Enter Email",
                                  icon: Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) => value!.isEmpty ||
                                          !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                              .hasMatch(value)
                                      ? 'Enter a valid email'
                                      : null,
                                ),
                                const SizedBox(height: 15),
                                _buildTextField(
                                  controller: passController,
                                  hintText: "Enter Password",
                                  icon: Icons.lock,
                                  obscureText: true,
                                  validator: (value) => value!.isEmpty ||
                                          value.length < 6
                                      ? 'Password must be at least 6 characters long'
                                      : null,
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(
                                      side: BorderSide(
                                          color: Colors.black, width: 2.2),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      addUser();
                                    }
                                  },
                                  icon: const Icon(Icons.login),
                                  label: const Text('Signup'),
                                ),
                                const SizedBox(height: 50),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2.0, 2.0),
                                            blurRadius: 3.0,
                                            color: Color.fromARGB(
                                                128, 248, 244, 244),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const Login(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicPicker() {
    return Column(
      children: [
        _imageBytes != null
            ? CircleAvatar(
                radius: 50,
                backgroundImage: MemoryImage(_imageBytes!),
              )
            : const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
        TextButton(
          onPressed: _pickImage,
          child: const Text('Select Profile Picture'),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
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
        hintText: hintText,
        suffixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }

  Future<void> _pickImage() async {
    try {
      if (foundation.kIsWeb) {
        final html.FileUploadInputElement uploadInput =
            html.FileUploadInputElement();
        uploadInput.accept = 'image/*';
        uploadInput.click();

        uploadInput.onChange.listen((e) async {
          final files = uploadInput.files;
          if (files!.isEmpty) return;
          final reader = html.FileReader();
          reader.readAsArrayBuffer(files[0]);
          reader.onLoadEnd.listen((e) {
            setState(() {
              _imageBytes = reader.result as Uint8List;
            });
          });
        });
      } else {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _imageBytes = bytes;
          });
        }
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> addUser() async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    String userName = nameController.text;
    String userPass = passController.text;
    String userEmail = emailController.text;

    String? imageUrl;
    if (_imageBytes != null && !foundation.kIsWeb) {
      try {
        final storageRef =
            FirebaseStorage.instance.ref().child('profile_pics/${userEmail}');
        final uploadTask = storageRef.putData(_imageBytes!);
        final snapshot = await uploadTask.whenComplete(() {});
        imageUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    try {
      await users.doc(userEmail).set({
        'id': userEmail, // Use email as ID
        'name': userName,
        'email': userEmail,
        'password': userPass, // Consider hashing the password before storing
        'userrole': 'customer',
        'image': imageUrl ??
            "", // Use uploaded image URL or empty string if no image
        'address': ""
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup successful'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } catch (e) {
      print("Error adding user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error signing up'),
        ),
      );
    }
  }
}
