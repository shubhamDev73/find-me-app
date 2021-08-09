import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:findme/constant.dart';
import 'package:findme/models/found.dart';
import 'package:findme/widgets/misc.dart';

class ChatMessageItem extends StatelessWidget {

  final String message;
  final String time;
  final bool me;
  final int borderState; // 0: normal, 1: first message, 2: last message

  ChatMessageItem({required this.message, required this.time, required this.me, this.borderState = 0});

  final circleRadius = Radius.circular(16.0);
  final flatRadius = Radius.zero;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                constraints: BoxConstraints(minWidth: 90, maxWidth: 250),
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: ThemeColors.chatMessageColors[me],
                  borderRadius: BorderRadius.only(
                    topLeft: me ? circleRadius : getCornerRadius(bottom: false),
                    bottomLeft: me ? circleRadius : getCornerRadius(bottom: true),

                    topRight: me ? getCornerRadius(bottom: false) : circleRadius,
                    bottomRight: me ? getCornerRadius(bottom: true) : circleRadius,
                  ),
                ),
                child: Text(
                  message,
                  textAlign: me ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Positioned(
                bottom: 3,
                right: 10,
                child: Container(
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black26,
                    ),
                  ),
                ),
              ),
            ],
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

class LastSeenWidget extends StatelessWidget {

  final Found found;
  LastSeenWidget({required this.found});

  final DatabaseReference realtimeDB = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return createStreamWidget<Event>(realtimeDB.child("${found.id}-${3 - found.me}").onValue, (Event e) {
      dynamic data = e.snapshot.value;
      if(data['online']){
        return Text(
          data['typing'] ? "typing..." : "currently active",
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontStyle: data['typing'] ? FontStyle.italic : FontStyle.normal,
          ),
        );
      }else{
        return DateWidget(endDate: DateTime.fromMillisecondsSinceEpoch(data['lastSeen']), prefix: 'last seen\n', textStyle: TextStyle(
          color: Colors.white,
          fontSize: 11,
        ),
          align: TextAlign.right
        );
      }
    }, fullPage: false);
  }
}
