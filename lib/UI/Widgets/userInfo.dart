import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:findme/configs/assets.dart';
import 'package:findme/data/models/user.dart';

class UserInfo extends StatelessWidget {

  final User user;

  UserInfo(this.user);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: 170,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                child: Center(
                  child: Image.network(
                    user.avatar,
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
              Positioned(
                top: 25,
                left: 130,
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
              SizedBox(
                height: 18,
              ),
              Text(
                user.nick,
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
