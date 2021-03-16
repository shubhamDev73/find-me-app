import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/chatItems.dart';
import 'package:findme/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/assets.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class ChatMessage extends StatelessWidget {

  final int messageLimit = 50;
  final TextEditingController messageController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Found found = ModalRoute.of(context).settings.arguments as Found;
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
      .collection('chats')
      .doc(found.chatId)
      .collection('chats')
      .orderBy('timestamp', descending: true)
      .limit(messageLimit)
      .snapshots();

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: ThemeColors.primaryColor,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            globals.setAnotherUser('/found/${found.id}');
                            Navigator.of(context).pushNamed('/user');
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 12.0),
                            child: CachedNetworkImage(imageUrl: found.avatar['v1'], height: 75),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              found.nick,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "currently active",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/mood/gloomy_bg.png"), fit: BoxFit.cover),
                  ),
                  child: createFirebaseStreamWidget(stream, (List<DocumentSnapshot> messages) {
                    globals.founds.mappedUpdate(found.id, (Found found) {
                      found.lastMessage = globals.getMessageJSON(messages[0]);
                      found.unreadNum = 0;
                      return found;
                    });
                    POST('found/read/', jsonEncode({"id": found.id}));

                    ScrollController scrollController = ScrollController();
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      scrollController.jumpTo(scrollController.position.maxScrollExtent);
                    });

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        reverse: true,
                        controller: scrollController,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot message = messages[index];
                          int borderState = 0;
                          if(index == messages.length - 1 || messages[index + 1]['user'] != message['user']) borderState = 1;
                          else if(index == 0 || messages[index - 1]['user'] != message['user']) borderState = 2;
                          return ChatMessageItem(
                            message: message['message'],
                            time: formatDate(timestamp: message['timestamp']),
                            me: message['user'] == found.me,
                            borderState: borderState,
                          );
                        },
                      ),
                    );
                  }, fullPage: false),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Color(0xFFB2EBF2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: TextField(
                          controller: messageController,
                          onSubmitted: (text) => submitChat(text, found),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                      child: InkWell(
                        onTap: () {
                          submitChat(messageController.text, found);
                          FocusScope.of(context).unfocus();
                        },
                        child: SvgPicture.asset(Assets.chatArrow),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitChat (String text, Found found) {
    FirebaseFirestore.instance.collection('chats').doc(found.chatId).collection('chats').add({
      'message': text,
      'user': found.me,
      'timestamp': FieldValue.serverTimestamp(),
    });
    messageController.clear();
  }

}
