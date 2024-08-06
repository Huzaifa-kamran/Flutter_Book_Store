import 'package:bookstore/appstyle.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final double rating; // Assuming you have a rating system

  const BookCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 105,
                height: 130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl), // Use NetworkImage for dynamic image URL
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 5),
                            // Fixed width for product description
                            Container(
                              width: screenWidth * 0.35, // Adjust width as needed
                              child: Text(
                                description,
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2, // Adjust max lines as needed
                              ),
                            ),
                            SizedBox(height: 5),
                            Text("\$ $price", style: AppStyle.subHeading()),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                );
                              }),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                              child: Text(
                                "Add to cart",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
