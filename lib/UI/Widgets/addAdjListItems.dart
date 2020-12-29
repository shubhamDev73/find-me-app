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
    return AdjDisplay(adj: adj, des: des, des2: des2);
  }
}

class AdjDisplay extends StatelessWidget {
  const AdjDisplay({
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
    return SizedBox(
      width: 340,
      height: 206,
      child: Container(
        constraints: BoxConstraints(
            minWidth: 340, minHeight: 206, maxWidth: 340, maxHeight: 206),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F7FA),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            ////////////////////////////////////////////////////////////////
            Positioned(
              top: 10,
              child: Container(
                constraints: BoxConstraints(
                    minWidth: 142, minHeight: 24, maxWidth: 142, maxHeight: 24),
                margin: EdgeInsets.fromLTRB(
                  101.0,
                  0.0,
                  97.0,
                  0.0,
                ),
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
                      minWidth: 270,
                      minHeight: 18,
                      maxWidth: 270,
                      maxHeight: 48),
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
            ////////////////////////////////////////////////////////////////
            Positioned(
              bottom: 14,
              child: Container(
                constraints: BoxConstraints(
                    minHeight: 31, minWidth: 101, maxWidth: 101, maxHeight: 31),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Explore",
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
