import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_model.dart';
import 'bookClass.dart';
import 'productDetail.dart';

class BookCard extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String author;
  final double price;
  final double rating;
  final bool favorite;

  const BookCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.author,
    required this.price,
    required this.rating,
    required this.favorite,
  });

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isWishlisted = false;
  bool _isLoggedIn = false;
  String? email;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _checkIfWishlisted();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    setState(() {
      _isLoggedIn = email != null;
    });
  }

  Future<void> _checkIfWishlisted() async {
    if (_isLoggedIn != false) {
      setState(() {
        isWishlisted = false; // Not logged in, cannot be wishlisted
      });
      return;
    }

    try {
      final wishlistDoc = await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(email)
          .collection('books')
          .doc(widget.id)
          .get();

      setState(() {
        isWishlisted = wishlistDoc.exists;
      });
    } catch (e) {
      print('Error checking wishlist: $e');
    }
  }

  Future<void> _toggleWishlist() async {
    if (_isLoggedIn == false) {
      _showLoginPrompt();
      return;
    }

    final wishlistRef = FirebaseFirestore.instance
        .collection('wishlist')
        .doc(email)
        .collection('books')
        .doc(widget.id);

    try {
      if (isWishlisted) {
        await wishlistRef.delete();
      } else {
        await wishlistRef.set({
          'id': widget.id,
          'imageUrl': widget.imageUrl,
          'title': widget.title,
          'author': widget.author,
          'price': widget.price,
        });
      }

      setState(() {
        isWishlisted = !isWishlisted;
      });
    } catch (e) {
      print('Error toggling wishlist: $e');
    }
  }

  void _showLoginPrompt() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please log in to add books to your wishlist.'),
        backgroundColor: Colors.red,
      ),
    );
  }

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
                      builder: (context) =>
                          ProductDetailPage(productId: widget.id),
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
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
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
                        builder: (context) =>
                            ProductDetailPage(productId: widget.id),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.description,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "\$${widget.price.toStringAsFixed(2)}",
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
                            index < widget.rating
                                ? Icons.star
                                : Icons.star_border,
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
                  IconButton(
                    icon: Icon(
                      widget.favorite != false ? Icons.favorite : Icons.favorite_border,
                      color:  widget.favorite !=false ? Colors.red : Colors.grey,
                      // isWishlisted ? Icons.favorite : Icons.favorite_border,
                      // color: isWishlisted ? Colors.red : Colors.grey,
                      
                    ),
                    onPressed: _toggleWishlist,
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      final cart =
                          Provider.of<CartModel>(context, listen: false);
                      final book = Book(
                        id: widget.id,
                        imageUrl: widget.imageUrl,
                        title: widget.title,
                        author: widget.author,
                        price: widget.price,
                      );

                      if (cart.isInCart(book)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${widget.title} is already in the cart'),
                            backgroundColor: Colors.orange,
                            duration: Duration(milliseconds: 600),
                          ),
                        );
                      } else {
                        cart.add(book);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.title} added to cart'),
                            backgroundColor: Colors.green,
                            duration: Duration(milliseconds: 600),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Consumer<CartModel>(
                      builder: (context, cart, child) {
                        final book = Book(
                          id: widget.id,
                          imageUrl: widget.imageUrl,
                          title: widget.title,
                          author: widget.author,
                          price: widget.price,
                        );

                        return Container(
                          child: cart.isInCart(book)
                              ? Icon(Icons.check, color: Colors.white)
                              : Text("Add to Cart",
                                  style: TextStyle(color: Colors.white)),
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
