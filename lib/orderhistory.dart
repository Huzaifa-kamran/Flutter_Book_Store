import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersHistoryPage extends StatefulWidget {
  const OrdersHistoryPage({super.key});

  @override
  State<OrdersHistoryPage> createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<OrdersHistoryPage> {
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: _email == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Orders')
                  .where('userEmail', isEqualTo: _email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No orders found'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var order = snapshot.data!.docs[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      child: ListTile(
                        title: Text('Order ID: ${order.id}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Order Date: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(order['orderDate']))}'),
                            Row(
                              children: [
                                Text('Status:'),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text(
                                    order['status'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  decoration: BoxDecoration(
                                    color: order['status'] == 'accepted'
                                        ? Colors.green
                                        : order['status'] == 'declined'
                                            ? Colors.red
                                            : Colors.orange,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                            Text('Total Amount: \$${order['totalAmount']}'),
                          ],
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return OrderDetailModal(order: order);
                            },
                          );
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

class OrderDetailModal extends StatelessWidget {
  final DocumentSnapshot order;

  const OrderDetailModal({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List items = order['items'];
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Order ID: ${order.id}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
              'Order Date: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(order['orderDate']))}'),
          SizedBox(height: 10),
          Text('Status: ${order['status']}'),
          SizedBox(height: 10),
          Text('Total Amount: \$${order['totalAmount']}'),
          SizedBox(height: 10),
          Text('Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ...items.map((item) {
            return ListTile(
              title: Text(item['title']),
              subtitle: Text(
                  'Quantity: ${item['quantity']} - Price: \$${item['price']}'),
            );
          }).toList(),
        ],
      ),
    );
  }
}
