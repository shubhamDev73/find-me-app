import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:findme/models/found.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

class ChatListItem extends StatelessWidget {

  final Found found;
  final int index;

  ChatListItem({required this.found, this.index = 0});

  @override
  Widget build (BuildContext context) {
    DatabaseReference realtimeFound = FirebaseDatabase.instance.reference().child("${found.id}-${found.me}");
    realtimeFound.update({
      'online': true,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
      'typing': false,
    });
    realtimeFound.onDisconnect().update({
      'online': false,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
      'typing': false,
    });

    return GestureDetector(
      onTap: () {
        if(found.lastMessage == null){
          globals.setAnotherUser('/found/${found.id}');
          Navigator.of(context).pushNamed('/user', arguments: found);
        }else{
          Navigator.of(context).pushNamed('/message', arguments: found);
        }
      },
      child: Container(
        color: ThemeColors.chatListColors[index % 2 == 0],
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(17),
                  child: CachedNetworkImage(imageUrl: found.avatar['v1'], height: 40),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      found.nick,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 200, maxHeight: 20),
                      child: Text(
                        found.lastMessage == null ? 'New connect!' : found.lastMessage!['message'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontStyle: found.lastMessage == null ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ),
            found.lastMessage == null || found.unreadNum <= 0 ? Container() : Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DateWidget(endDate: DateTime.parse(found.lastMessage!['timestamp']), textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  )),
                  Container(
                    padding: EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeColors.primaryColor,
                    ),
                    child: Text(
                      found.unreadNum.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
