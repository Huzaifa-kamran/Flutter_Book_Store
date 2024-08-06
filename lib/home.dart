import 'package:bookstore/appstyle.dart';
import 'package:bookstore/bookCard.dart';
import 'package:bookstore/customAppBar.dart';
import 'package:bookstore/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction Container
            Container(
              width: screenWidth * 0.95,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Discover your \nbest books now",
                    style: AppStyle.mainHeading(),
                  ),
                  SizedBox(height: 7),
                  Text(
                    "Find your dream book according to your preference \nand join to our family, What are you waiting for.",
                    style: TextStyle(color: Colors.grey, height: 1.3),
                  ),
                ],
              ),
            ),

            // Search Bar
            Center(
              child: Container(
                width: screenWidth * 0.92,
                margin: EdgeInsets.only(top: 10),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Search book here...",
                  ),
                ),
              ),
            ),

            // Horizontal Scrollable Products
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    width: screenWidth * 1,
                    height: 170,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/homeBanner.jpg"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 167, 166, 164),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: screenWidth * 0.7,
                    height: 170,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 167, 166, 164),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Categories Section
            Container(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Categories",
                style: AppStyle.subHeading(),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 28,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "Category",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      height: 28,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "Category",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      height: 28,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "Category",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      height: 28,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "Category",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      height: 28,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "Category",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Top Products Section
            Container(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Top Products",
                style: AppStyle.subHeading(),
              ),
            ),
            SizedBox(height: 10),

            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("Books").snapshots(),
                builder: (context, snapshot) {
                   final data = snapshot.requireData;
          return ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index) {
            var book = data.docs[index];
            return BookCard(
              title: book['title'],
              description: book['description'],
              imageUrl: book['imageUrl'],
              price: book['price'].toDouble(),
              rating: book['rating'].toDouble(), // Assuming there's a rating field
            );
          },
        );
                }),

            BookCard(
                title: "book",
                description: "lorem ipsum sadas ",
                imageUrl: "images/book.jpg",
                price: 23,
                rating: 3)
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
