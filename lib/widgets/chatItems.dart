import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:findme/models/found.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/constant.dart';
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

class FoundListItem extends StatefulWidget {

  final Found found;
  final int index;
  final Stream<QuerySnapshot> lastMessage;

  FoundListItem({this.found, this.index = 0, this.lastMessage});

  @override
  _FoundListItemState createState() => _FoundListItemState();
}

class _FoundListItemState extends State<FoundListItem> {

  Stream<QuerySnapshot> unreadDocsStream;

  @override
  void initState () {
    super.initState();
    updateStream();
    globals.onTimeChanges[widget.found.chatId] = () {
      setState((){updateStream();});
    };
  }

  @override
  void dispose () {
    super.dispose();
    globals.onTimeChanges.remove(widget.found.chatId);
  }

  void updateStream () {
    unreadDocsStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.found.chatId)
        .collection('chats')
        .where('user', isEqualTo: 3 - widget.found.me)
        .where('timestamp', isGreaterThanOrEqualTo: new Timestamp.fromMillisecondsSinceEpoch(globals.lastReadTimes[widget.found.chatId]))
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
                      Text(
                        formatDate(endDate: messages[0]['timestamp'].toDate()),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
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
