import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:findme/models/found.dart';
import 'package:findme/models/fakeDocument.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

class ChatListItem extends StatelessWidget {

  final Found found;
  final int index;

  ChatListItem({this.found, this.index = 0});

  final StreamController<int> unreadNumController = StreamController<int>();

  DateTime lastMessageTime;

  void syncWithFound (Found found) {
    unreadNumController.add(found.unreadNum);
    lastMessageTime = found.lastMessage == null ? DateTime.fromMillisecondsSinceEpoch(0) : DateTime.parse(found.lastMessage['timestamp']);
  }

  @override
  Widget build (BuildContext context) {
    Stream<QuerySnapshot> lastMessage = FirebaseFirestore.instance
        .collection('chats')
        .doc(found.chatId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
    syncWithFound(found);
    globals.onFoundChanged[found.id] = syncWithFound;

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
        child: createFirebaseStreamWidget(lastMessage, (messages) {
          dynamic message = messages.length > 0 ? messages[0] : null;
          DateTime dateTime;
          if(message != null && message['timestamp'] != null){
            dateTime = message['timestamp'] is String ? DateTime.parse(message['timestamp']) : message['timestamp'].toDate();
            if(dateTime.compareTo(lastMessageTime) > 0)
              globals.founds.mappedUpdate(found.id, (Found found) {
                found.lastMessage = globals.getMessageJSON(message);
                if(message['user'] != found.me)
                  found.unreadNum++;
                return found;
              });
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(17),
                    child: CachedNetworkImage(imageUrl: found.avatar['v1'], height: 40),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                          message == null ? 'New connect!' : message['message'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontStyle: message == null ? FontStyle.italic : FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
              ),
              message == null ? Container() : createStreamWidget<int>(unreadNumController.stream, (int num) => Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: num > 0 ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    DateWidget(endDate: dateTime, textStyle: TextStyle(
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
                        "$num",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ) : Container(),
              ), fullPage: false),
            ],
          );
        }, fullPage: false, cacheObj: [found.lastMessage == null ? null : FakeDocument(id: found.lastMessage['id'], data: found.lastMessage)]),
      ),
    );
  }
}
