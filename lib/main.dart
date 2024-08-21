import 'package:bookstore/Profile.dart';
import 'package:bookstore/addbooks.dart';
import 'package:bookstore/cart.dart';
import 'package:bookstore/favorite.dart';
import 'package:bookstore/home.dart';
import 'package:bookstore/login.dart';
import 'package:bookstore/productDetail.dart';
import 'package:bookstore/splash.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart'; // Import your CartModel

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCz11G-y7W4oUYHEN7nxkEUSVU6j2twsGQ',
      appId: '1:527638839997:android:6c00d262e472d06eb02dd4',
      messagingSenderId: '527638839997',
      projectId: 'book-store-e6aa6',
      storageBucket: 'book-store-e6aa6.appspot.com',
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartModel(), // Provide CartModel here
        ),
      ],
      child: const MyApp(), // Ensure you are using the correct root widget
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Splash(), // Ensure you are using the correct root widget
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late final List<Widget> pages;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    pages = const [
      Home(),
      Favorite(),
      Cart(),
      Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        color: Colors.black,
        backgroundColor:
            Colors.transparent, // Updated to transparent for better visibility
        index: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.favorite_border_outlined, color: Colors.white),
          Icon(Icons.shopping_basket, color: Colors.white),
          Icon(Icons.person_2_outlined, color: Colors.white),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
