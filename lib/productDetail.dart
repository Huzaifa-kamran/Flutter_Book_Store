import 'package:bookstore/appstyle.dart';
import 'package:bookstore/customAppBar.dart';
import 'package:bookstore/drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Detail Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductDetailPage(),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:CustomAppBar(),
      drawer: AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: 
          
          Padding(
            padding: const EdgeInsets.all(15.0), // Padding around the image
            child: Stack(
              children: [
                Container(
                  width: screenWidth * 0.7,
                  height: 325,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    border: Border.all(
                      color: Color.fromARGB(255, 233, 228, 228),
                      width: 35,
                    ), // Border around the image
                  ),
                  child: ClipRRect(
                    child: Image.asset(
                      'images/book2.jpg',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
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
          ),),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Row(
                          children: [
                            Icon(Icons.star,color: Colors.amber,),
                            Icon(Icons.star,color: Colors.amber,),
                            Icon(Icons.star,color: Colors.amber,),
                            Icon(Icons.star,color: Colors.amber,),
                            Icon(Icons.star,color: Colors.amber,),

                            SizedBox(width: 8,),
                            Text("4.0",style: AppStyle.subHeading(),)
                          ],
                        ),
          ),
             
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Product Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Product Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam nec vestibulum lacus.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Price: \$99.99',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Spacer(), // Pushes the button to the bottom of the page
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle Add to Cart button press
              },
              style: ElevatedButton.styleFrom(
               
                minimumSize: Size(double.infinity, 50),backgroundColor: const Color.fromARGB(255, 0, 0, 0) // Full width and fixed height
              ),
              child: Text('Add to Cart',style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),),
            ),
          ),
        ],
      ),
    );
  }
}
