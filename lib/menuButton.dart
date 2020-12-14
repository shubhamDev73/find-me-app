import 'package:flutter/material.dart';

Widget menuButton({key, context}) {
  final snackBar = SnackBar(
    content: Text(key),
    action: SnackBarAction(
      label: "Undo",
      onPressed: () {},
    ),
  );
  return InkWell(
    onTap: () {
      context.currentState.showSnackBar(snackBar);
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 10,
            color: Colors.grey.shade400,
            spreadRadius: 0,
          ),
        ],
      ),
      height: 50,
      width: 50,
    ),
  );
}
