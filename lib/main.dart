import 'package:bookstore/Profile.dart';
import 'package:bookstore/adminPanel.dart';
import 'package:bookstore/books.dart';
import 'package:bookstore/cart.dart';
import 'package:bookstore/favorite.dart';
import 'package:bookstore/home.dart';
import 'package:bookstore/login.dart';
import 'package:bookstore/splash.dart';
import 'package:bookstore/userProfile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCz11G-y7W4oUYHEN7nxkEUSVU6j2twsGQ',
          appId: '1:527638839997:android:6c00d262e472d06eb02dd4',
          messagingSenderId: '527638839997',
          projectId: 'book-store-e6aa6',
          storageBucket: 'book-store-e6aa6.appspot.com'));

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Profile(),
  ));
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late List<Widget> pages;

  late Home HomePage;
  late Favorite FavoritePage;
  late Cart CartPage;
  late UserProfile UserProfilePage;
  int currentIndex = 0;
  @override
  void initState() {
    HomePage = Home();
    FavoritePage = Favorite();
    CartPage = Cart();
    UserProfilePage = UserProfile();
    pages = [HomePage, FavoritePage, CartPage, UserProfilePage];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          color: Colors.black,
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.favorite_border_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.person_2_outlined,
              color: Colors.white,
            ),
          ]),
      body: pages[currentIndex],
    );
  }
}
