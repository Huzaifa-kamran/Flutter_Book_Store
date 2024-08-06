import 'package:bookstore/customAppBar.dart';
import 'package:bookstore/drawer.dart';
import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<Book> favoriteBooks = [
    Book(
      title: '1984',
      author: 'George Orwell',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcFpiMmJyCO06XbTBjNsRSuNhBGqRJgpuwGg&s',
    ),
    Book(
      title: 'To Kill a Mockingbird',
      author: 'Harper Lee',
      imageUrl: 'https://via.placeholder.com/150x300?text=To+Kill+a+Mockingbird',
    ),
    Book(
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      imageUrl: 'https://via.placeholder.com/150x300?text=The+Great+Gatsby',
    ),
    Book(
      title: 'Moby Dick',
      author: 'Herman Melville',
      imageUrl: 'https://via.placeholder.com/150x300?text=Moby+Dick',
    ),
  ];

  void _removeBook(Book book) {
    setState(() {
      favoriteBooks.remove(book);
    });
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
    // var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: favoriteBooks.length > 0  ? Column(
          children: favoriteBooks.map((book) {
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
                          image: NetworkImage(book.imageUrl),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                child: Text("Remove",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                              ),
                          ],),
                          
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text(
                            '\$50',
                            style: TextStyle(color: const Color.fromARGB(255, 80, 79, 79),fontSize: 20),
                          ),
                          IconButton(
                            icon: Icon(Icons.shopping_cart,color: Colors.black,),
                            onPressed: () => _addToCart(book),
                            color: Colors.white,
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
          }).toList() ,
        ): Material(
          child: Center(
           child: Column(
          children: [
            SizedBox(height: 50,),
            Container(
              child: Image.asset("images/wishlistbg.png"),
            ),
            Text("Your wishlist is empty",
            style: TextStyle(color: Colors.grey,fontSize: 25),)
          ],
        ),
      ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}

class Book {
  final String title;
  final String author;
  final String imageUrl;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
  });

}