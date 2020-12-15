import 'package:findme/configs/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                child: Center(
                  child: Image.asset(
                    Assets.avatar,
                  ),
                ),
              ),
              Positioned(
                top: 15,
                left: 96,
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.white),
                  child: SvgPicture.asset(
                    Assets.edit,
                    height: 50,
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
