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
                top: 10,
                left: 165,
                child: SvgPicture.asset(
                  Assets.edit,
                  width: 25,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          user.nick,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
