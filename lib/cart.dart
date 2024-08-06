import 'package:bookstore/customAppBar.dart';
import 'package:bookstore/drawer.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Container(
              child: Image.asset("images/cartbg.png"),
            ),
            Text("Your Cart is empty",
            style: TextStyle(color: Colors.grey,fontSize: 25),)
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}