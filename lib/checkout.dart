import 'package:bookstore/bookClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPage extends StatefulWidget {
  final List<Book> cartItems;
  final double totalAmount;

  CheckoutPage({required this.cartItems, required this.totalAmount});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  final _addressController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        _addressController.text = data['address'] ?? '';
        _email = data['email'] ?? '';
      }
    }
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> orderData = {
        'userEmail': _email,
        'address': _addressController.text,
        'cardNumber': _cardNumberController.text,
        'expiryDate': _expiryDateController.text,
        'cvv': _cvvController.text,
        'totalAmount': widget.totalAmount,
        'items': widget.cartItems.map((item) => item.toMap()).toList(),
        'orderDate': DateTime.now().toIso8601String(),
        'status':'pending'
      };

      try {
        await FirebaseFirestore.instance.collection('orders').add(orderData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Order placed successfully!'),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to place order: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String labelText,
      TextInputType? keyboardType,
      bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.atm),
        labelText: labelText, border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(130, 14, 23, 199),
                                        width: 3.0),
                                  ),),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                  controller: _addressController, labelText: 'Address'),
                  SizedBox(height: 12,),
              _buildTextField(
                  controller: _cardNumberController,
                  labelText: 'Card Number',
                  keyboardType: TextInputType.number),
                  SizedBox(height: 12,),
              _buildTextField(
                  controller: _expiryDateController,
                  labelText: 'Expiry Date (MM/YY)',
                  keyboardType: TextInputType.datetime),
                  SizedBox(height: 12,),
              _buildTextField(
                  controller: _cvvController,
                  labelText: 'CVV',
                  keyboardType: TextInputType.number,
                  obscureText: true),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Place Order',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
