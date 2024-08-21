import 'package:bookstore/addbooks.dart';
import 'package:bookstore/catagories.dart';
import 'package:bookstore/login.dart';
import 'package:bookstore/orders.dart';
import 'package:bookstore/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int totalUsers = 0;
  int totalBooks = 0;
  int totalOrders = 0;
  int totalCategories = 0;

  @override
  void initState() {
    super.initState();
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    // Fetch total users count
    var userSnapshot =
        await FirebaseFirestore.instance.collection('Users').get();
    setState(() {
      totalUsers = userSnapshot.size;
    });

    // Fetch total books count
    var bookSnapshot =
        await FirebaseFirestore.instance.collection('Books').get();
    setState(() {
      totalBooks = bookSnapshot.size;
    });

    // Fetch total orders count
    var orderSnapshot =
        await FirebaseFirestore.instance.collection('Orders').get();
    setState(() {
      totalOrders = orderSnapshot.size;
    });

    // Fetch total categories count
    var categorySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    setState(() {
      totalCategories = categorySnapshot.size;
    });
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
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Displaying total counts using Wrap to avoid overflow
            Wrap(
              spacing: 10, // spacing between cards horizontally
              runSpacing: 10, // spacing between cards vertically
              alignment: WrapAlignment.center,
              children: [
                _buildInfoCard('Total Users', totalUsers, Colors.blue),
                _buildInfoCard('Total Books', totalBooks, Colors.green),
                _buildInfoCard('Total Orders', totalOrders, Colors.orange),
                _buildInfoCard(
                    'Total Categories', totalCategories, Colors.purple),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildAdminButton(
                    context,
                    icon: Icons.book,
                    label: 'Manage Books',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManageBooks()),
                      );
                    },
                  ),
                  _buildAdminButton(
                    context,
                    icon: Icons.person,
                    label: 'Manage Users',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManageUsers()),
                      );
                    },
                  ),
                  _buildAdminButton(
                    context,
                    icon: Icons.shopping_cart,
                    label: 'Manage Orders',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManageOrders()),
                      );
                    },
                  ),
                  _buildAdminButton(
                    context,
                    icon: Icons.category,
                    label: 'Manage Categories',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManageCategories()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, int count, Color color) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 120, // Adjusted width
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent, // Background color
        foregroundColor: Colors.white, // Text color
        padding: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
