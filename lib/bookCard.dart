import 'package:bookstore/productDetail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart'; // Adjust the path if necessary
import 'bookClass.dart'; // Adjust the path if necessary

class BookCard extends StatelessWidget {
  final String id; // Added id parameter
  final String imageUrl;
  final String title;
  final String description;
  final String author;
  final double price;
  final double rating;

  const BookCard({
    super.key,
    required this.id, // Required id parameter
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.author,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.4;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      width: containerWidth,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                   Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(productId: id),
                  ),
                );
                },
                child: Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
             Expanded(
              child: GestureDetector(
                  onTap: () {
                   Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(productId: id),
                  ),
                );
                },
             child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "\$${price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        );
                      }),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
             
              ),
              

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, color: Colors.red),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      final cart = Provider.of<CartModel>(context, listen: false);
                      final book = Book(
                        id: id,
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
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Consumer<CartModel>(
                      builder: (context, cart, child) {
                        final book = Book(
                          id: id,
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
