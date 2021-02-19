import 'package:flutter/material.dart';

import 'package:findme/globals.dart' as globals;

class FindListItem extends StatelessWidget {

  final int id;
  final String avatar;

  FindListItem({this.id, this.avatar});

  @override
  Widget build (BuildContext context) {
    return InkWell(
      onTap: () {
        globals.getAnotherUser('/find/$id');
        Navigator.of(context).pushNamed('/user');
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 7.0, 0.0, 0.0),
        child: Image.network(avatar, width: 70),
      ),
    );
  }

}
