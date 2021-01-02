import 'package:flutter/material.dart';

class AdjListItem extends StatelessWidget {
  const AdjListItem({
    Key key,
    @required this.adj,
    @required this.des,
    @required this.des2,
  }) : super(key: key);

  final String adj;
  final String des;
  final String des2;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 10,
            child: Container(
              constraints: BoxConstraints(
                  minWidth: 142, minHeight: 24, maxWidth: 142, maxHeight: 24),
              child: Center(
                child: Text(
                  "$adj", // adjective title --  needs to be updated dynamically
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          ////////////////////////////////////////////////////////////////
          Positioned(
            top: 34,
            child: Container(
              constraints: BoxConstraints(
                  minWidth: 50, minHeight: 17, maxWidth: 180, maxHeight: 17),
              child: Center(
                child: Text(
                  "$des", // adjective title --  needs to be updated dynamically
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          ////////////////////////////////////////////////////////////////
          Positioned(
            top: 60,
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
          ////////////////////////////////////////////////////////////////
          Positioned(
            top: 77,
            child: Container(
                constraints: BoxConstraints(
                    minWidth: 270, minHeight: 18, maxWidth: 270, maxHeight: 48),
                child: Text(
                  '$des2',
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                )),
          ),
        ],
      ),
    );
  }
}
