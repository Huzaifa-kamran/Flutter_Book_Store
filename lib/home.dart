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

//      StreamBuilder(
//   stream: FirebaseFirestore.instance.collection("Books").snapshots(),
//   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     // Check for errors
//     if (snapshot.hasError) {
//       return Center(child: Text('Something went wrong'));
//     }

//     // Check for data availability
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return Center(child: CircularProgressIndicator());
//     }

//     // Retrieve the data
//     final data = snapshot.requireData;

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: data.size,
//       itemBuilder: (context, index) {
//         var book = data.docs[index];
//         var imageUrl = book['imageUrl'].trim(); // Ensure no leading/trailing whitespace

//         print('Loading image: $imageUrl'); // Debugging: Print the URL

//         return Container(
//           height: 200,
//           width: 200,
//           child: Image.network(
//             imageUrl,
//             fit: BoxFit.cover,
//             loadingBuilder: (context, child, loadingProgress) {
//               if (loadingProgress == null) return child;
//               return Center(
//                 child: CircularProgressIndicator(
//                   value: loadingProgress.expectedTotalBytes != null
//                       ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
//                       : null,
//                 ),
//               );
//             },
//             errorBuilder: (context, error, stackTrace) {
//               print('Error loading image: $error'); // Debugging: Print the error
//               return Center(child: Text('Image not available'));
//             },
//           ),
//         );
//       },
//     );
//   },
// )

 StreamBuilder(
  stream:FirebaseFirestore.instance.collection("Books").snapshots(),
  builder: (context,snapshots){
        return ListView.builder(
        shrinkWrap:true,
        itemCount: snapshots.data!.docs.length,
        itemBuilder: (context,index){
          DocumentSnapshot documentSnapshot = snapshots.data!.docs[index];
          return Dismissible(
            onDismissed: (direction){
                    // deleteTodos(documentSnapshot["todoTitle"]);
            },
            key:Key(documentSnapshot["title"]), 
            child:Card(
              elevation: 4,
              margin: EdgeInsets.all(8),
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title:Text(documentSnapshot["title"]),
                trailing: IconButton(icon: Icon(Icons.delete, color:Colors.red),
                onPressed:(){
                  setState(() {
                    // deleteTodos(documentSnapshot["todoTitle"]);
                  });
                }),
              ),
            ));
        });
      }),


          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
