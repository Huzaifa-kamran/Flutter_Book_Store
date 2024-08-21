import 'package:bookstore/bookClass.dart';
import 'package:bookstore/cart_model.dart';
import 'package:bookstore/customAppBar.dart';
import 'package:bookstore/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({Key? key, required this.productId}) : super(key: key);

  Future<Map<String, dynamic>?> fetchProductDetails(String id) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Books').doc(id).get();
      if (doc.exists) {
        print('Document data: ${doc.data()}');  // Log document data
        return doc.data() as Map<String, dynamic>?;
      } else {
        print('No document found with id: $id');  // Log if no document found
        throw Exception("Product not found");
      }
    } catch (e) {
      print('Error fetching product details: $e');  // Log the error
      throw Exception("Error fetching product details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color.fromRGBO(250, 250, 249, 1),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context); // Navigate back to the previous page when the back button is tapped
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.white,
      ),
      body:
       FutureBuilder<Map<String, dynamic>?>(
        future: fetchProductDetails(productId),  // Correctly pass the future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            var productData = snapshot.data!;
            var imageUrl = productData['imageUrl'] ?? '';
            var title = productData['title'] ?? 'No title';
            var description = productData['description'] ?? 'No description';
            var author = productData['author'] ?? 'Unknown author';
            var price = (productData['price'] ?? 0.0) as double;
            var rating = (productData['rating'] ?? 0.0) as double;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 325,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color.fromARGB(255, 233, 228, 228),
                                width: 10,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                imageUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: Icon(Icons.favorite_border),
                              color: Colors.red,
                              iconSize: 33,
                              onPressed: () {
                                // Handle heart icon press
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                    child: Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          );
                        }),
                        SizedBox(width: 8),
                        Text(
                          "$rating",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Price: \$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final cart = Provider.of<CartModel>(context, listen: false);
                        final book = Book(
                          id: productId,
                          imageUrl: imageUrl,
                          title: title,
                          author: author,
                          price: price,
                        );

                        if (cart.isInCart(book)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$title is already in the cart'),
                              backgroundColor: Colors.orange,
                              duration: Duration(milliseconds: 600),
                            ),
                          );
                        } else {
                          cart.add(book);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$title added to cart'),
                              backgroundColor: Colors.green,
                              duration: Duration(milliseconds: 600),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        
                      ),
                      child: Consumer<CartModel>(
                        builder: (context, cart, child) {
                          final book = Book(
                            id: productId,
                            imageUrl: imageUrl,
                            title: title,
                            author: author,
                            price: price,
                          );

                          return Container(
                            child: cart.isInCart(book)
                                ? Icon(Icons.check, color: Colors.white)
                                : Text("Add to Cart", style: TextStyle(color: Colors.white)),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
