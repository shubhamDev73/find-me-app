import 'package:flutter/material.dart';

class AdjListItem extends StatelessWidget {
  const AdjListItem({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        Container(
          height: 1.25,
          width: 200.0,
          color: Colors.black,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: 270,
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
