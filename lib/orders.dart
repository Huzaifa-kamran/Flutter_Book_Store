import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageOrders extends StatefulWidget {
  const ManageOrders({super.key});

  @override
  _ManageOrdersState createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return ListTile(
                title: Text('Order ID: ${order.id}'),
                subtitle: Text('User: ${order['user_email']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Orders')
                        .doc(order.id)
                        .delete();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
