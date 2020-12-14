import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Greating extends StatelessWidget {
  const Greating({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      color: Color(0xffDFF7F9),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Text(
                "Konichiwa!",
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Text(
              "Did you know the US armys traning bumbelbees to sniff out explosive?",
              textAlign: TextAlign.center,
              style: GoogleFonts.comfortaa(
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
