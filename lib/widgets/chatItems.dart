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
        globals.setAnotherUser('/$baseUrl/$id');
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
              padding: const EdgeInsets.all(7.0),
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

class ChatMessageItem extends StatelessWidget {

  final String message;
  final String time;
  final bool me;
  final int borderState; // 0: normal, 1: first message, 2: last message

  ChatMessageItem({this.message, this.time, this.me, this.borderState = 0});

  final circleRadius = Radius.circular(16.0);
  final flatRadius = Radius.zero;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(minWidth: 70, maxWidth: 250),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: me ? Color(0xFFF0FBFD) : Color(0xFF82D6E1),
              borderRadius: BorderRadius.only(
                topLeft: me ? circleRadius : getCornerRadius(bottom: false),
                bottomLeft: me ? circleRadius : getCornerRadius(bottom: true),

                topRight: me ? getCornerRadius(bottom: false) : circleRadius,
                bottomRight: me ? getCornerRadius(bottom: true) : circleRadius,
              ),
            ),
            child: Text(message),
          ),
        ],
      ),
    );
  }

  Radius getCornerRadius ({bool bottom = false}) {
    if(borderState == 0) return flatRadius;
    if(borderState == 1) return bottom ? flatRadius : circleRadius;
    if(borderState == 2) return bottom ? circleRadius : flatRadius;
    return circleRadius;
  }

}
