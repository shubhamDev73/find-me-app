import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

class InterestButton extends StatefulWidget {
  final Function onClick;
  final String name;
  final int amount;
  final bool selected;
  final bool isSvg;
  final bool canChangeAmount;

  InterestButton({this.onClick, this.name, this.amount = 0, this.selected = false, this.canChangeAmount = false, this.isSvg = false});

  @override
  _InterestButtonState createState() => _InterestButtonState();
}

class _InterestButtonState extends State<InterestButton> {

  int amount;

  @override
  void initState() {
    super.initState();
    amount = widget.amount;
    if(widget.canChangeAmount) globals.onUserChanged['interestButton${widget.name}'] = () => setState(() {});
  }

  @override
  void dispose() {
    if(widget.canChangeAmount) globals.onUserChanged.remove('interestButton${widget.name}');
    super.dispose();
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
          color: ThemeColors.interestColors[widget.canChangeAmount ? amount : widget.amount],
          border: widget.selected ? Border.all(
            color: Colors.black,
            width: 2,
          ) : null,
        ),
        height: 35,
        width: 100,
        child: Center(
          child: widget.isSvg ? SvgPicture.asset(widget.name) :
          Text(
            widget.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
