import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
          child: Container(
            child: Center(
              child: CachedNetworkImage(imageUrl: user.avatar['v2']),
            ),
          ),
        ),
        SizedBox(height: 12),
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
