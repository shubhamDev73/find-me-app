import 'package:flutter/material.dart';
import 'package:findme/constant.dart';

class InterestButton extends StatefulWidget {
  final Function onClick;
  final String name;
  final int amount;
  final bool selected;
  final bool canChangeAmount;

  InterestButton({this.onClick, this.name, this.amount = 0, this.selected = false, this.canChangeAmount = false});

  @override
  _InterestButtonState createState() => _InterestButtonState();
}

class _InterestButtonState extends State<InterestButton> {

  int amount;

  @override
  void initState() {
    super.initState();
    amount = widget.amount;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.canChangeAmount ? () {
        setState(() {
          amount = (amount + 1) % 4;
        });
        widget.onClick(amount);
      } : widget.onClick,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: ThemeColors.interestColors[amount],
          border: widget.selected ? Border.all(
            color: Colors.black,
            width: 2,
          ) : null,
        ),
        height: 35,
        width: 95,
        child: Center(
          child: Text(
            widget.name,
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
