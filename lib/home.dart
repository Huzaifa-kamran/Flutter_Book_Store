import 'package:bookstore/appstyle.dart';
import 'package:bookstore/bookCard.dart';
// import 'package:bookstore/customAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? selectedCategory;
  String? email;
  TextEditingController searchController = TextEditingController();

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 249, 1),
      // appBar: CustomAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: screenWidth * 0.95,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 13),
              child: Column(
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
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Search book here...",
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Trigger re-build to apply search filter
                    });
                  },
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
                    width: screenWidth,
                    height: 170,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/homeBanner.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 167, 166, 164),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child:
                          Text('Error fetching categories: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No categories available.'));
                }

                var categories = snapshot.data?.docs ?? [];

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      String categoryName = category['name'] ?? '';
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = selectedCategory == categoryName
                                ? null
                                : categoryName;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedCategory == categoryName
                                ? Colors.blue
                                : Colors.black,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              categoryName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: getBooksStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('Error fetching books: ${snapshot.error}'),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('No books available at the moment.'),
                  ),
                );
              }

              var data = snapshot.data?.docs ?? [];

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var book = data[index].data() as Map<String, dynamic>;
                    bool favorite = false;
                    FirebaseFirestore.instance
                        .collection("wishlist")
                        .doc(email)
                        .collection('Books')
                        .doc(data[index].id)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        favorite = true;
                      } else {
                        favorite = false;
                        // The document does not exist
                        // Handle the non-existent document case
                      }
                    });
                    return BookCard(
                      id: data[index].id,
                      imageUrl: book['imageUrl'] ?? '',
                      title: book['title'] ?? '',
                      description: book['description'] ?? '',
                      author: book['author'] ?? '',
                      price: book['price']?.toDouble() ?? 0.0,
                      rating: book['rating']?.toDouble() ?? 0.0,
                      favorite: favorite,
                    );
                  },
                  childCount: data.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> getBooksStream() {
    Query<Map<String, dynamic>> booksQuery =
        FirebaseFirestore.instance.collection('Books');

    // Apply search filter
    if (searchController.text.isNotEmpty) {
      String search = searchController.text.toLowerCase();
      booksQuery = booksQuery
          .where('title', isGreaterThanOrEqualTo: search)
          .where('title', isLessThanOrEqualTo: search + '\uf8ff');
    }

    // Apply category filter
    if (selectedCategory != null) {
      booksQuery = booksQuery.where('category', isEqualTo: selectedCategory);
    }

    // No sorting applied
    // booksQuery = booksQuery.orderBy(sortBy, descending: !sortAscending);

    return booksQuery.snapshots();
  }
}
