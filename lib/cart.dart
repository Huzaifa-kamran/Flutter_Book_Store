import 'package:bookstore/checkout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_model.dart';
import 'bookClass.dart';
import 'login.dart';
import 'snackbar.dart'; // Ensure you import the snackbar.dart file

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    setState(() {
      _isLoggedIn = email != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 249, 1),
      body: cart.items.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      var book = cart.items[index];
                      return _buildCartItem(book, cart);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handleCheckout(context, cart),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Checkout (\$${cart.totalAmount.toStringAsFixed(2)})',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : _buildEmptyCartMessage(),
    );
  }

  Widget _buildCartItem(Book book, CartModel cart) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
        contentPadding: EdgeInsets.all(8.0),
        leading: Container(
          width: 50,
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              book.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(book.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Author: ${book.author}'),
            Text('Price: \$${book.price.toStringAsFixed(2)}'),
            Text('Total: \$${book.totalPrice.toStringAsFixed(2)}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => cart.decreaseQuantity(book),
            ),
            Text(book.quantity.toString()),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => cart.increaseQuantity(book),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                cart.remove(book);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${book.title} removed from cart'),
                    backgroundColor: Colors.red,
                    duration: Duration(milliseconds: 600),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCartMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset("images/cartbg.jpg"),
          ),
          Text(
            "Your Basket is empty and Sad",
            style: TextStyle(color: Colors.grey, fontSize: 25),
          ),
          Text(
            "on the inside",
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
          Text(
            "Add Products to make it Happy!!",
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCheckout(BuildContext context, CartModel cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutPage(
            cartItems: cart.items,
            totalAmount: cart.totalAmount,
          ),
        ),
      );
    } else {
      CustomSnackbar.showSnackbar(
        context,
        'Please login to continue the process',
        type: SnackbarType.error,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }
  }
}
