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

   // final containerWidth = screenWidth * 0.2;

    return Scaffold(
       backgroundColor: Color.fromRGBO(250, 250, 249, 1),
      appBar: CustomAppBar(),
      body:  CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
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
                    "Find your dream book according to your preference \nand join our family. What are you waiting for?",
                    style: TextStyle(color: Colors.grey, height: 1.3),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
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
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
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
                  // width: screenWidth * 0.5,
                  //  height: 170,
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Categories",
                style: AppStyle.subHeading(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(5, (index) {
                  return Container(
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
                  );
                }),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Top Products",
                style: AppStyle.subHeading(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Books").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshot.hasData || snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('Error fetching data')),
                );
              }

              var data = snapshot.data?.docs;

              if (data == null || data.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('No books available')),
                );
              }

              // Create a list of books with their details
              List<Map<String, dynamic>> books = [];
              for (var e in data) {
                var book = {
                  'id': e.id,
                  'title': e["title"] ?? '',
                  'description': e["description"] ?? '',
                  'author': e["author"] ?? '',
                  'imageUrl': e["imageUrl"] ?? '',
                  'price': e["price"]?.toDouble() ?? 0.0,
                  // 'rating': e["rating"]?.toDouble() ?? 0.0,
                };
                books.add(book);
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index){
              
                    var book = books[index];
                  //  book['imageUrl']?print(book['imageUrl']):print("No Image");
                    if (book['imageUrl'] != null) {
                      // return Image.network(book['imageUrl'], fit: BoxFit.cover);
                    }
                    return BookCard(
                      id:book['id'] ,
                      imageUrl: book['imageUrl'],
                      title: book['title'],
                      description: book['description'],
                      author: book['author'],
                      price: book['price'],
                      rating: 4,
                    );
                  },
                  childCount: books.length,
                ),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
