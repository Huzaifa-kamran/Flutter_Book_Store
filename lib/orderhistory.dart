import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class OrdersHistoryPage extends StatefulWidget {
  @override
  _OrdersHistoryPageState createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<OrdersHistoryPage> {
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
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
                  .collection('orders')
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
                            Text('Order Date: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(order['orderDate']))}'),
                            Row(
                              children: [
                            Text('Status:'),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                              child: 
                            Text(order['status'],style: TextStyle(color: Colors.white),),
                            decoration: BoxDecoration(
                              color:order['status'] == 'completed'? Color.fromARGB(255, 29, 168, 101):Color.fromARGB(255, 238, 167, 74),
                              borderRadius: BorderRadius.circular(10),
                            ),

                            )
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
  final QueryDocumentSnapshot order;

  OrderDetailModal({required this.order});

  @override
  Widget build(BuildContext context) {
    var items = (order['items'] as List).map((item) => item as Map<String, dynamic>).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order ID: ${order.id}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Order Date: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(order['orderDate']))}'),
          Text('Status: ${order['status']}'),
          Text('Total Amount: \$${order['totalAmount']}'),
          Divider(),
          Text('Items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                return ListTile(
                  title: Text(item['title']),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
