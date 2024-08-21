import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool _isLoggedIn = false;
  String? _userEmail;

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
      _userEmail = email;
    });
  }

  Future<void> _removeBook(Book book) async {
    if (_userEmail == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(_userEmail)
          .collection('Books')
          .doc(book.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('${book.title} removed from wishlist!'),
        ),
      );
    } catch (e) {
      print('Error removing book: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to remove book. Please try again.'),
        ),
      );
    }

    setState(() {}); // Rebuild the UI
  }

  void _addToCart(Book book) {
    // Add your cart logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('${book.title} added to cart!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return Scaffold(
        body: Center(
          child: Text('Please log in to view your wishlist.'),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wishlist')
            .doc(_userEmail)
            .collection('Books')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found.'));
          }

          var wishlistBooks = snapshot.data?.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return Book(
              id: doc.id,
              title: data['title'] ?? 'Unknown Title',
              author: data['author'] ?? 'Unknown Author',
              imageUrl: data['imageUrl'] ?? '',
              price: data['price']?.toDouble() ?? 0.0,
            );
          }).toList();

          if (wishlistBooks == null || wishlistBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/wishlistbg.png"),
                  SizedBox(height: 20),
                  Text(
                    "Your wishlist is empty",
                    style: TextStyle(color: Colors.grey, fontSize: 25),
                  )
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: wishlistBooks.map((book) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 105,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(book.imageUrl.isNotEmpty
                                  ? book.imageUrl
                                  : 'https://example.com/placeholder.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    book.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => _removeBook(book),
                                    child: Text(
                                      "Remove",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${book.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 80, 79, 79),
                                        fontSize: 20),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.black,
                                    ),
                                    onPressed: () => _addToCart(book),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final double price;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.price,
  });
}
