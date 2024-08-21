import 'package:bookstore/checkout.dart';
import 'package:bookstore/customAppBar.dart';
import 'package:bookstore/drawer.dart';
import 'package:bookstore/login.dart';
import 'package:bookstore/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_model.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool _isLoggedIn = false;

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email != null) {
      setState(() {
        _isLoggedIn = true;
   
      });
    } else {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);

    return Scaffold(
       backgroundColor: Color.fromRGBO(250, 250, 249, 1),
      appBar: CustomAppBar(),
      body: cart.items.length > 0?
      Column(
        children: [      
Expanded(
  child: ListView.builder(
    itemCount: cart.items.length,
    itemBuilder: (context, index) {
      var book = cart.items[index];
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Optional: Add margin around the card
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the card
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color with opacity
              spreadRadius: 2, // Spread of the shadow
              blurRadius: 8, // Blur radius of the shadow
              offset: Offset(0, 4), // Offset of the shadow
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(8.0), // Optional: Add padding inside the card
          leading: Container(
            width: 50, // Set a fixed width for the image
            height: 75, // Set a fixed height for the image
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), // Match border radius for rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1), // Light shadow for the image
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5), // Match border radius for rounded corners
              child: Image.network(
                book.imageUrl,
                fit: BoxFit.cover, // Adjust the fit property as needed
              ),
            ),
          ),
          title: Text(book.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Author: ${book.author}'), // Fixed typo in 'Author'
              Text('Price: \$${book.price.toStringAsFixed(2)}'),
              Text('Total: \$${book.totalPrice.toStringAsFixed(2)}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  cart.decreaseQuantity(book);
                },
              ),
              Text(book.quantity.toString()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  cart.increaseQuantity(book);
                },
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
    },
  ),
),


          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: 

ElevatedButton(
  onPressed: () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email'); // Check if 'email' exists

    if (email != null) {
      // User is logged in, navigate to the CheckoutPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutPage(cartItems: cart.items, totalAmount: cart.totalAmount),
        ),
      );
    } else {
      // User is not logged in, navigate to the Login page
      CustomSnackbar.showSnackbar(
              context, 'Please login to continue the proccess', "error");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(), // Assuming you have a Login page
        ),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  child: Text(
    'Checkout (\$${cart.totalAmount.toStringAsFixed(2)})',
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
  ),
),
            ),
           // Inside your Cart page, when navigating to the Checkout page





          ),
        ],
      ):
      Center(
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
                  )
                ],
              ),
            ),

      drawer: AppDrawer(),
    );
  }
}
