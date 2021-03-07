import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:findme/models/found.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

class ChatListItem extends StatefulWidget {

  final Found found;
  final int index;
  final Stream<QuerySnapshot> lastMessage;

  ChatListItem({this.found, this.index = 0, this.lastMessage});

  @override
  _ChatListItemState createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {

  Stream<QuerySnapshot> unreadDocsStream;

  @override
  void initState () {
    super.initState();
    updateStream();
    globals.onTimeChanged[widget.found.chatId] = () {
      setState((){updateStream();});
    };
  }

  @override
  void dispose () {
    super.dispose();
    globals.onTimeChanged.remove(widget.found.chatId);
  }

  void updateStream () {
    int timestamp = globals.lastReadTimes.mappedGetValue(widget.found.chatId);
    unreadDocsStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.found.chatId)
        .collection('chats')
        .where('user', isEqualTo: 3 - widget.found.me)
        .where('timestamp', isGreaterThanOrEqualTo: new Timestamp.fromMillisecondsSinceEpoch(timestamp))
        .snapshots();
  }

  @override
  Widget build (BuildContext context) {
    return createFirebaseStreamWidget(widget.lastMessage, (List<DocumentSnapshot> messages) => GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/message',
            arguments: widget.found);
      },
      child: ColoredBox(
        color: widget.index % 2 == 0 ? Colors.grey[300] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(17.0, 17.0, 17.0, 14.0),
                      child: Image.network(widget.found.avatar, height: 40),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.found.nick,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 200, maxHeight: 20),
                          child: Text(
                            messages[0]['message'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: createFirebaseStreamWidget(unreadDocsStream, (List<DocumentSnapshot> unreadMessages) {
                  int num = unreadMessages.length;
                  return num > 0 ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      DateWidget(endDate: messages[0]['timestamp'].toDate()),
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
                  ) : Container();
                }),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class DateWidget extends StatefulWidget {

  final DateTime endDate;

  DateWidget({this.endDate});

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {

  Timer timer;

  @override
  void initState () {
    super.initState();
    timer = Timer.periodic(new Duration(minutes: 1), (timer) {setState(() {});});
  }

  @override
  Widget build (BuildContext context) {
    return Text(
      formatDate(endDate: widget.endDate),
      style: TextStyle(
        color: Colors.black,
        fontSize: 12,
      ),
    );
  }

  @override
  void dispose () {
    super.dispose();
    timer.cancel();
  }

}
