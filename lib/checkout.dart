import 'package:bookstore/cart_model.dart';
import 'package:bookstore/cartempty.dart';
import 'package:bookstore/recipt.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Add this import for FilteringTextInputFormatter
import 'bookClass.dart';
import 'custom_input_formatters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPage extends StatefulWidget {
  final List<Book> cartItems;
  final double totalAmount;

  CheckoutPage({required this.cartItems, required this.totalAmount});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  Future<void> addOrder() async {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('Orders');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('email');
    DateTime orderDate = DateTime.now();

    try {
      await orders.add({
        'userEmail': userEmail,
        'items': widget.cartItems
            .map((book) => {
                  'title': book.title,
                  'quantity': book.quantity,
                  'price': book.price,
                  'imageUrl': book.imageUrl
                })
            .toList(),
        'totalAmount': widget.totalAmount,
        'orderDate': orderDate.toIso8601String(),
        'status': 'pending', // Initial status
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully'),
        ),
      );

      // Navigate to the CheckoutReceipt page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutReceipt(
            cartItems: widget.cartItems,
            totalAmount: widget.totalAmount,
          ),
        ),
      );
    } catch (e) {
      print("Error adding order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error placing order'),
        ),
      );
    }
  }

  void showPaymentForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Payment Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cardNumberController,
                decoration: InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CardNumberInputFormatter(),
                ],
              ),
              TextField(
                controller: expiryDateController,
                decoration: InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ExpiryDateInputFormatter(),
                ],
              ),
              TextField(
                controller: cvvController,
                decoration: InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                handlePayment(
                  cardNumberController.text,
                  expiryDateController.text,
                  cvvController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Confirm Payment'),
            ),
          ],
        );
      },
    );
  }

  Future<void> handlePayment(
      String cardNumber, String expDate, String cvv) async {
    // Simulate payment processing
    await Future.delayed(Duration(seconds: 2)); // Simulate a delay

    // Simple validation check
    if (cardNumber.isNotEmpty && expDate.isNotEmpty && cvv.isNotEmpty) {
      await addOrder();
      Cartempty();
    } else {
      print('Invalid card information');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid payment information'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Items in Cart:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  var book = widget.cartItems[index];
                  return ListTile(
                    title: Text(book.title),
                    subtitle: Text(
                        'Quantity: ${book.quantity} - Price: \$${book.price.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Text('Total Amount: \$${widget.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: showPaymentForm,
                child: Text('Continue to Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
