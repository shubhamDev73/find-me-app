import 'package:flutter/material.dart';

import 'package:findme/globals.dart' as globals;

class RequestListItem extends StatelessWidget {

  final int id;
  final String avatar;

  RequestListItem({this.id, this.avatar});

  @override
  Widget build (BuildContext context) {
    return InkWell(
      onTap: () {
        globals.getAnotherUser('/requests/$id');
        Navigator.of(context).pushNamed('/user');
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        padding: const EdgeInsets.fromLTRB(12.0, 7.0, 0.0, 0.0),
        child: Image.network(avatar, width: 70),
      ),
    );
  }

}

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
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: Colors.white),
        ),
        padding: const EdgeInsets.fromLTRB(12.0, 7.0, 0.0, 0.0),
        child: Image.network(avatar, width: 70),
      ),
    );
  }

}
