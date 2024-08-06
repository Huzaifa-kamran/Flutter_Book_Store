import 'dart:ui';

import 'package:bookstore/adminPanel.dart';
import 'package:bookstore/customerPanel.dart';
import 'package:bookstore/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userEmail = new TextEditingController();
  TextEditingController userPassword = new TextEditingController();

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
            color: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.2),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.1),
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: containerHeight),
                        const Text(
                          "Login",
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
                          "Enter your Credential to Login",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: 300,
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: userEmail,
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
                                        width: 3.0),
                                  ),
                                  hintText: "Enter Email",
                                  suffixIcon: const Icon(Icons.email),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: userPassword,
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
                                        width: 3.0),
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
                                  userLogin(userEmail.text, userPassword.text);
                                },
                                icon: const Icon(Icons.login),
                                label: const Text('Login'),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(2.0, 2.0),
                                          blurRadius: 3.0,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Signup(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Signup',
                                    ),
                                  ),
                                ],
                              )
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

  Future<void> userLogin(String email, String password) async {
    DocumentSnapshot user_data =
        await FirebaseFirestore.instance.collection('Users').doc(email).get();

    var userFetchData = user_data.data();

    if (userFetchData is Map<String, dynamic>) {
      var userRole = userFetchData["userrole"];
      var userName = userFetchData['name'];

      if (userRole == "admin") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login Successful Welcome ' + userName),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2)));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AdminPanel()));
      } else if (userRole == "customer") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login Successful Welcome ' + userName),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const CustomerPanel()));
      }
    } else {
      print("credential wrong");
    }
  }
}
