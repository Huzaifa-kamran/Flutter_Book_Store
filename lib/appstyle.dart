import 'package:flutter/material.dart';

class AppStyle{
  
  static TextStyle mainHeading(){
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 34,
      height: 0.98,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle subHeading(){
    return TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
      fontFamily: 'Poppins',
    );
  }
}