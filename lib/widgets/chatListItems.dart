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

class ChatList extends StatefulWidget {

  final Map<int, Found> founds;
  ChatList({this.founds});

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  List<Found> foundList;

  @override
  void initState () {
    super.initState();
    globals.onChatListUpdate = (Map<int, Found> founds) =>
      Timer(const Duration(milliseconds: 100), () =>
        setState(() {
          assignFoundList(founds);
        })
      );
  }

  @override
  void dispose () {
    super.dispose();
    globals.onChatListUpdate = null;
    for(Found found in foundList){
      FirebaseDatabase.instance.reference().child("${found.id}-${found.me}").update({
        'online': false,
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  void assignFoundList (Map<int, Found> founds) {
    foundList = founds.values.toList();
    foundList.sort((Found a, Found b) {
      if(a.lastMessage == null) return -1;
      if(b.lastMessage == null) return 1;
      DateTime aDate = DateTime.parse(a.lastMessage['timestamp']);
      DateTime bDate = DateTime.parse(b.lastMessage['timestamp']);
      return bDate.compareTo(aDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(foundList == null)
      assignFoundList(widget.founds);

    return ListView.builder(
      itemBuilder: (context, index) => ChatListItem(
        found: foundList[index],
        index: index,
      ),
      itemCount: foundList.length,
    );
  }
}

class ChatListItem extends StatelessWidget {

  final Found found;
  final int index;

  ChatListItem({this.found, this.index = 0});

  final DatabaseReference realtimeDB = FirebaseDatabase.instance.reference();
  final StreamController<int> unreadNumController = StreamController<int>();
  Stream<QuerySnapshot> lastMessage;
  DateTime lastMessageTime;

  void syncWithFound (Found found) {
    unreadNumController.add(found.unreadNum);
    lastMessageTime = found.lastMessage == null ? DateTime.fromMillisecondsSinceEpoch(0) : DateTime.parse(found.lastMessage['timestamp']);
  }

  @override
  Widget build (BuildContext context) {
    if(lastMessageTime == null){
      realtimeDB.child("${found.id}-${found.me}").update({
        'online': true,
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
      });
      realtimeDB.child("${found.id}-${found.me}").onDisconnect().update({
        'online': false,
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
      });
      lastMessage = FirebaseFirestore.instance
          .collection('chats')
          .doc(found.chatId)
          .collection('chats')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots();
      syncWithFound(found);
      globals.onFoundChanged[found.id] = syncWithFound;
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/message',
            arguments: found);
      },
      child: ColoredBox(
        color: index % 2 == 0 ? Colors.grey[300] : Colors.white,
        child: Container(
          child: createFirebaseStreamWidget(lastMessage, (messages) {
            dynamic message = messages.length > 0 ? messages[0] : null;
            DateTime dateTime;
            if(message != null){
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
                      padding: const EdgeInsets.fromLTRB(17.0, 17.0, 17.0, 14.0),
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
          }, fullPage: false, cacheObj: [FakeDocument(id: found.lastMessage == null ? '' : found.lastMessage['id'], data: found.lastMessage)]),
        ),
      ),
    );
  }
}
