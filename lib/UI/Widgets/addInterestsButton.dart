import 'package:flutter/material.dart';
import 'package:findme/constant.dart';

class InterestButton extends StatelessWidget {
  final Function function;
  final String name;
  final int amount;
  final bool selected;

  InterestButton({this.function, this.name, this.amount, this.selected});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: ThemeColors.interestColors[amount],
          border: selected
              ? Border.all(
                  color: Colors.black,
                  width: 2,
                )
              : null,
        ),
        height: 28,
        width: 94,
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
