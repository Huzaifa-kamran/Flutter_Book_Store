import 'dart:ui';

import 'package:bookstore/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController idController = TextEditingController(text: '1');
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = screenHeight * 0.2;
    return Scaffold(
       appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context); // Navigate back to the previous page when the back button is tapped
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      ),
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
                          child: Column(
                            children: [
                              Visibility(
                                visible: false,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: idController,
                                  decoration: const InputDecoration(
                                    hintText: "Enter User ID",
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
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
                                controller: emailController,
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
                                  hintText: "Enter Email",
                                  suffixIcon: const Icon(Icons.email),
                                ),
                                keyboardType: TextInputType.emailAddress,
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
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: 2.2),
                                  ),
                                ),
                                onPressed: () {
                                  addUser();
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
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

  void addUser() async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    String userId = idController.text;
    String userName = nameController.text;
    String userPass = passController.text;
    String userEmail = emailController.text;

    await users
        .doc(userEmail)
        .set({
          'id': userId,
          'name': userName,
          'email': userEmail,
          'password': userPass,
          'userrole': 'customer',
          'image': "",
          'address': ""
        })
        .then((value){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Signup Successful"),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
        })
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Signup Unsuccessful"),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            ));
    passController.clear();
    emailController.clear();
    nameController.clear();
  }
}
