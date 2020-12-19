import 'package:flutter/material.dart';

class ActivityButton extends StatelessWidget {
  final Function function;
  final String name;
  final int amount;
  ActivityButton({this.function, this.name, this.amount});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 8,
              color: Colors.grey.shade400,
              spreadRadius: 0,
            ),
          ],
          color: Color(0xff00ADC2).withOpacity(amount / 3.0),
        ),
        height: 35,
        width: 95,
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
