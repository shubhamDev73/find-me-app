import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:findme/assets.dart';
import 'package:findme/models/user.dart';

class UserInfo extends StatelessWidget {

  final User user;

  UserInfo(this.user);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 190,
          width: 190,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                child: Center(
                  child: CachedNetworkImage(imageUrl: user.avatar['v2']),
                ),
              ),
              Positioned(
                top: 30,
                left: 150,
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
                height: 4,
              ),
              Text(
                user.nick,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Lorem ipsum dolor sit amet",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
