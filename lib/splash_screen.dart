import 'dart:async';
import 'package:flutter/material.dart';
import 'package:buy/pages/login.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 227, 237, 241),
      child: Center(
        child: Transform.scale(
          scale: 0.65,
          child: Image.asset('assets/images/shopping.png'),
        ),
      ),
    );
  }
}
