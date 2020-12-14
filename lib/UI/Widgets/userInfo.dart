import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 130,
          width: 130,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 8,
                      color: Colors.grey.shade600,
                      spreadRadius: 0,
                    ),
                  ],
                  color: Colors.black,
                ),
                child: Center(
                  child: Icon(
                    Icons.supervised_user_circle,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 96,
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.black,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            children: [
              Text(
                "mckme",
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Lorem ipsum dolor sit amet",
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
