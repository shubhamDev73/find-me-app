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
  final Stream<QuerySnapshot> lastMessage;

  ChatListItem({this.found, this.index = 0, this.lastMessage});

  final StreamController<int> numController = StreamController<int>();
  int num;
  String lastMessageId;

  void assign (int n) {
    num = n;
    numController.add(num);
  }

  @override
  Widget build (BuildContext context) {
    if(num == null){
      assign(0);
      globals.onTimesChanged[found.chatId] = () => assign(0);
    }

    return createFutureWidget(globals.lastReadTimes.get(), (Map<String, int> times) {
      Future<QuerySnapshot> unreadDocsStream = FirebaseFirestore.instance
          .collection('chats')
          .doc(found.chatId)
          .collection('chats')
          .where('user', isEqualTo: 3 - found.me)
          .where('timestamp', isGreaterThanOrEqualTo: new Timestamp.fromMillisecondsSinceEpoch(times[found.chatId]))
          .get();

      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/message',
              arguments: found);
        },
        child: ColoredBox(
          color: index % 2 == 0 ? Colors.grey[300] : Colors.white,
          child: Container(
            child: createFutureWidget<QuerySnapshot>(unreadDocsStream, (QuerySnapshot unreadMessages) {
              assign(unreadMessages.docs.length);
              return createFirebaseStreamWidget(lastMessage, (List<DocumentSnapshot> messages) {
                DocumentSnapshot message = messages[0];
                if (lastMessageId == null)
                  lastMessageId = message.id;
                else if (lastMessageId != message.id && messages[0]['user'] != found.me) {
                  lastMessageId = message.id;
                  assign(num + 1);
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
                    createStreamWidget<int>(numController.stream, (int num) => Container(
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
              }, fullPage: false);
            }, fullPage: false),
          ),
        ),
      );
    }, fullPage: false);
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
