import 'package:flutter/material.dart';
import 'bookClass.dart'; // Replace with the actual path to your Book class

class CheckoutReceipt extends StatelessWidget {
  final List<Book> cartItems;
  final double totalAmount;

  CheckoutReceipt(
      {Key? key, required this.cartItems, required this.totalAmount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
        backgroundColor: Color.fromARGB(255, 31, 31, 31),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thank you for your purchase!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 29, 29, 29))),
            SizedBox(height: 20),
            Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text('Order Summary:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  var book = cartItems[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      leading: Container(
                        width: 50,
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 4),
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
                      title: Text(book.title,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          'Quantity: ${book.quantity} - Price: \$${book.price.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 21, 21, 21),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Back to Home',
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
    );
  }
}
