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

  Future<QuerySnapshot> unreadDocsStream;

  @override
  void initState () {
    super.initState();
    int timestamp = globals.lastReadTimes.mappedGetValue(widget.found.chatId);
    unreadDocsStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.found.chatId)
        .collection('chats')
        .where('user', isEqualTo: 3 - widget.found.me)
        .where('timestamp', isGreaterThanOrEqualTo: new Timestamp.fromMillisecondsSinceEpoch(timestamp))
        .get();
  }

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/message',
            arguments: widget.found);
      },
      child: ColoredBox(
        color: widget.index % 2 == 0 ? Colors.grey[300] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: createFutureWidget<QuerySnapshot>(unreadDocsStream, (QuerySnapshot unreadMessages) =>
            ChatListInfo(found: widget.found, lastMessage: widget.lastMessage, initNum: unreadMessages.docs.length)
          ),
        ),
      ),
    );
  }
}

class ChatListInfo extends StatefulWidget {

  final Found found;
  final Stream<QuerySnapshot> lastMessage;
  final int initNum;
  ChatListInfo({this.found, this.lastMessage, this.initNum});

  @override
  _ChatListInfoState createState() => _ChatListInfoState();
}

class _ChatListInfoState extends State<ChatListInfo> {

  String lastMessageId;
  int num;

  @override
  void initState () {
    super.initState();
    num = widget.initNum;
    globals.onTimesChanged[widget.found.chatId] = () {
      num = 0;
//      setState((){num = 0;});
    };
  }

  @override
  void dispose () {
    super.dispose();
    globals.onTimesChanged.remove(widget.found.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return createFirebaseStreamWidget(widget.lastMessage, (List<DocumentSnapshot> messages) {
      DocumentSnapshot message = messages[0];
      if(lastMessageId == null) lastMessageId = message.id;
      else if(lastMessageId != message.id && messages[0]['user'] != widget.found.me) {
        lastMessageId = message.id;
        num++;
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(17.0, 17.0, 17.0, 14.0),
                child: Image.network(widget.found.avatar['v1'], height: 40),
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
                      message['message'],
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
            child: num > 0 ? Column(
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
            ) : Container(),
          ),
        ],
      );
    });
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
