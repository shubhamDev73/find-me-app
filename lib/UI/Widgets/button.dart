import 'package:flutter/material.dart';
import 'dart:math';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String title;
  List color = [
    Colors.teal[50],
    Colors.teal[100],
    Colors.teal[200],
    Colors.teal[300],
    Colors.teal[400],
    Colors.teal[500],
  ];
  Random random = new Random();

  CustomButton(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 15,
        bottom: 10,
        left: 5,
      ),
      child: RaisedButton(
        color: color[random.nextInt(4)],
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: () {},
        child: Text(this.title),
      ),
    );
  }
}
