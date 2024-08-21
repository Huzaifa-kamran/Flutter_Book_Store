import 'package:bookstore/adminPanel.dart';
import 'package:bookstore/login.dart';
import 'package:bookstore/orderhistory.dart';
import 'package:bookstore/updateprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? _name;
  String? _email;
  String? _profileImageUrl;
  String? _role;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email != null) {
      setState(() {
        _isLoggedIn = true;
        _email = email;
      });
      getInfo(email);
    } else {
      setState(() {
        _isLoggedIn = false;
        _email = null; // Ensure that email is null if the user is not logged in
      });
    }
  }

  Future<void> getInfo(String email) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection("Users").doc(email).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        setState(() {
          _name = userData?['name'] ?? '';
          _profileImageUrl = userData?['profileImageUrl'];
          _role = userData?['userrole'];
        });
      } else {
        print("No user found with email: $email");
        setState(() {
          _isLoggedIn = false;
        });
      }
    } catch (e) {
      print("Failed to fetch user data: $e");
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Logout Successfully'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 249, 1),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _isLoggedIn && _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : AssetImage('images/user2.jpg') as ImageProvider,
                  ),
                  if (_isLoggedIn && _profileImageUrl != null)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          print("Edit Pic");
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              _isLoggedIn
                  ? Column(
                      children: [
                        Text(
                          _name ?? 'Loading...',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 2, 2, 2),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          _email ?? 'Loading...',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 105, 105, 105),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildProfileOption(
                          icon: Icons.person,
                          label: 'Update Profile',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateProfile(
                                        userEmail: _email ?? "")));
                          },
                        ),
                        SizedBox(height: 20),
                        _buildProfileOption(
                          icon: Icons.add_business,
                          label: 'Orders History',
                          onTap: () {
                            // Navigate to OrdersHistoryPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrdersHistoryPage(),
                              ),
                            );
                          },
                        ),
                        _role == "admin"
                            ? SizedBox(height: 20)
                            : SizedBox(
                                height: 2,
                              ),
                        _role == "admin"
                            ? _buildProfileOption(
                                icon: Icons.manage_accounts,
                                label: 'Dashboard',
                                onTap: () {
                                  // Navigate to OrdersHistoryPage
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminPanel(),
                                    ),
                                  );
                                },
                              )
                            : Material(),
                        SizedBox(height: 20),
                        _buildLogoutButton(),
                      ],
                    )
                  : Center(
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                backgroundColor: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color.fromARGB(172, 223, 216, 216)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    size: 25,
                  ),
                  SizedBox(width: 20),
                  Text(
                    label,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: const Color.fromARGB(255, 0, 0, 0),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color.fromARGB(255, 0, 0, 0)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: InkWell(
          onTap: logout,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Logout',
                style: TextStyle(
                  color: Color.fromARGB(255, 250, 250, 250),
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.logout,
                color: Color.fromARGB(255, 248, 248, 248),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
