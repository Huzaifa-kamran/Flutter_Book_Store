import 'package:bookstore/books.dart';
import 'package:bookstore/orders.dart';
import 'package:bookstore/users.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Add logout functionality here
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageBooks()),
                );
              },
              child: const Text('Manage Books'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageUsers()),
                );
              },
              child: const Text('Manage Users'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageOrders()),
                );
              },
              child: const Text('Manage Orders'),
            ),
          ],
        ),
      ),
    );
  }
}
