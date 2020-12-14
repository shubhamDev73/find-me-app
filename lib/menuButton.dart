import 'package:flutter/material.dart';

Widget menuButton({key, scaffoldKey, selected, icon}) {
  final snackBar = SnackBar(
    content: Text(key),
    action: SnackBarAction(
      label: "Undo",
      onPressed: () {},
    ),
  );
  return Expanded(
    flex: 2,
    child: InkWell(
      onTap: () {
        scaffoldKey.currentState.showSnackBar(snackBar);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: selected ? Radius.circular(0.0) : Radius.circular(8.0),
            topRight: selected ? Radius.circular(0.0) : Radius.circular(0.0),
          ),
          color: selected ? Colors.white : Color(0xff00ACC1),
        ),
        height: 84,
        width: 50,
        child: Icon(
          icon,
          color: selected ? Color(0xff00ACC1) : Colors.white,
        ),
      ),
    ),
  );
}
