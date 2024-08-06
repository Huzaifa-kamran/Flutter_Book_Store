import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:bookstore/main.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Main()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = screenHeight * 0.2;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/books.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            height: containerHeight,
            color: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.4),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 23, 23, 23).withOpacity(0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
