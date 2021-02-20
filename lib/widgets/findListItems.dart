import 'package:flutter/material.dart';

import 'package:findme/globals.dart' as globals;

class FindListItem extends StatelessWidget {

  final int id;
  final String avatar;
  final String nick;
  final bool isRequest;

  FindListItem({this.id, this.avatar, this.nick, this.isRequest = false});

  @override
  Widget build (BuildContext context) {
    return InkWell(
      onTap: () {
        String baseUrl = isRequest ? 'requests' : 'find';
        globals.getAnotherUser('/$baseUrl/$id');
        Navigator.of(context).pushNamed('/user');
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
              shape: BoxShape.circle,
                color: isRequest ? Colors.white : Colors.transparent,
                border: Border.all(color: Colors.white),
              ),
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.fromLTRB(12.0, 7.0, 0.0, 0.0),
              child: Image.network(avatar, width: 50),
            ),
            Text(
              nick,
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

}
