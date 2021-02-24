import 'package:flutter/material.dart';

class AdjListItem extends StatelessWidget {
  const AdjListItem({
    Key key,
    @required this.name,
    @required this.description,
  }) : super(key: key);

  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 20,
            child: Container(
              constraints: BoxConstraints(minWidth: 142, minHeight: 24, maxWidth: 142, maxHeight: 24),
              child: Center(
                child: Text(
                  "$name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 57,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.0),
              child: Center(
                child: Container(
                  height: 1.25,
                  width: 200.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            top: 77,
            child: Container(
                constraints: BoxConstraints(minWidth: 270, minHeight: 18, maxWidth: 270, maxHeight: 48),
                child: Text(
                  '$description',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
            ),
          ),
        ],
      ),
    );
  }
}
