import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:findme/models/found.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

class ChatListItem extends StatelessWidget {

  final Found found;
  final int index;

  ChatListItem({this.found, this.index = 0});

  final StreamController<int> unreadNumController = StreamController<int>();
  Stream<QuerySnapshot> lastMessage;
  int unreadNum;
  String lastMessageId;

  void assignUnreadNum (int n) {
    unreadNum = n;
    unreadNumController.add(unreadNum);
  }

  @override
  Widget build (BuildContext context) {
    if(unreadNum == null){
      lastMessage = FirebaseFirestore.instance
          .collection('chats')
          .doc(found.chatId)
          .collection('chats')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots();
      lastMessageId = found.lastMessage['id'];
      assignUnreadNum(found.unreadNum);
      globals.onTimesChanged[found.chatId] = () => assignUnreadNum(0);
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/message',
            arguments: found);
      },
      child: ColoredBox(
        color: index % 2 == 0 ? Colors.grey[300] : Colors.white,
        child: Container(
          child: createFirebaseStreamWidget(lastMessage, (List<DocumentSnapshot> messages) {
            DocumentSnapshot message = messages.length > 0 ? messages[0] : null;
            if(message != null)
              if (lastMessageId != message.id && message['user'] != found.me) {
                lastMessageId = message.id;
                assignUnreadNum(unreadNum + 1);
              }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(17.0, 17.0, 17.0, 14.0),
                      child: Image.network(found.avatar['v1'], height: 40),
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
                      DateWidget(endDate: message['timestamp'].toDate()),
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
          }, fullPage: false),
        ),
      ),
    );
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
