import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderManagePage extends StatefulWidget {
  const OrderManagePage({super.key});

  @override
  _OrderManagePageState createState() => _OrderManagePageState();
}

class _OrderManagePageState extends State<OrderManagePage> {
  final CollectionReference _ordersRef = FirebaseFirestore.instance.collection('orders');

  Future<void> _updateOrderStatus(String orderId, String status) async {
    try {
      await _ordersRef.doc(orderId).update({'status': status});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Order status updated to $status'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update order status: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _buildOrderItem(DocumentSnapshot orderDoc) {
    Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;
    String? orderId = orderDoc.id;
    String? status = orderData['status'];
    DateTime? orderDate = DateTime.parse(orderData['orderDate']);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        title: Text('Order ID: $orderId'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: $status'),
            Text('Date: ${_formatDate(orderDate)}'),
            Text('Total Amount: \$${orderData['totalAmount'].toStringAsFixed(2)}'),
          ],
        ),
        trailing: DropdownButton<String>(
          value: status,
          items: ['pending', 'completed']
              .map((status) => DropdownMenuItem(value: status, child: Text(status)))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              _updateOrderStatus(orderId, value);
            }
          },
        ),
        onTap: () => _showOrderDetailsModal(orderDoc),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  void _showOrderDetailsModal(DocumentSnapshot orderDoc) {
    Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order ID: ${orderDoc.id}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Status: ${orderData['status']}'),
              Text('Date: ${_formatDate(DateTime.parse(orderData['orderDate']))}'),
              Text('Address: ${orderData['address']}'),
              SizedBox(height: 10),
              Text('Items:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ...orderData['items'].map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('${item['title']} x${item['quantity']} (\$${item['totalPrice'].toStringAsFixed(2)})'),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map(_buildOrderItem).toList(),
          );
        },
      ),
    );
  }
}
