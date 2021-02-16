import 'package:flutter/material.dart';

class ConnectList extends StatelessWidget {

  final String avatar;

  ConnectList(this.avatar);

  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 7.0, 0.0, 0.0),
      child: Image.network(avatar, width: 70),
    );

  }
}
