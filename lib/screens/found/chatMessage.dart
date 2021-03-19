import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/chatItems.dart';
import 'package:findme/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/assets.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class ChatMessage extends StatelessWidget {

  final TextEditingController messageController = new TextEditingController();
  final DatabaseReference realtimeDB = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    Found found = ModalRoute.of(context).settings.arguments as Found;

    messageController.addListener(() {
      realtimeDB.child("${found.id}-${found.me}").update({
        'typing': messageController.text != '',
      });
    });

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
                      InkWell(
                        onTap: () {
                          globals.setAnotherUser('/found/${found.id}');
                          Navigator.of(context).pushNamed('/user');
                        },
                        child: Container(
                          width: 50,
                          margin: EdgeInsets.symmetric(horizontal: 12.0),
                          child: CachedNetworkImage(imageUrl: found.avatar['v1']),
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
                            child: LastSeenWidget(found: found),
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
                  child: ChatMessageList(found: found),
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
    realtimeDB.child("${found.id}-${found.me}").update({
      'typing': false,
    });
  }

}

class ChatMessageList extends StatefulWidget {

  final Found found;
  ChatMessageList({this.found});

  final int messageLimit = 50;
  final ScrollController scrollController = ScrollController();

  @override
  _ChatMessageListState createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {

  int currentMessageLimit;
  Stream<QuerySnapshot> stream;
  int downloadedMessages = 0;
  bool streamDownloaded = false;

  @override
  void initState () {
    super.initState();
    currentMessageLimit = widget.messageLimit;
    updateStream();
    streamDownloaded = true;
    widget.scrollController.addListener(() {
      double maxScroll = widget.scrollController.position.maxScrollExtent;
      double currentScroll = widget.scrollController.offset;
      if(streamDownloaded && maxScroll - currentScroll <= 40)
        setState(() {
          currentMessageLimit += widget.messageLimit;
          updateStream();
        });
    });
  }

  @override
  void dispose () {
    FirebaseDatabase.instance.reference().child("${widget.found.id}-${widget.found.me}").update({
      'typing': false,
    });
    super.dispose();
  }

  void updateStream () {
    stream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.found.chatId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .limit(currentMessageLimit)
        .snapshots();
    streamDownloaded = false;
  }

  @override
  Widget build(BuildContext context) {
    return createFirebaseStreamWidget(stream, (List<DocumentSnapshot> messages) {
      if(messages.length > downloadedMessages){
        streamDownloaded = true;
        downloadedMessages = messages.length;
        globals.founds.mappedUpdate(widget.found.id, (Found found) {
          found.lastMessage = globals.getMessageJSON(messages[0]);
          found.unreadNum = 0;
          return found;
        });
        POST('found/read/', jsonEncode({"id": widget.found.id}));
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          reverse: true,
          controller: widget.scrollController,
          itemCount: streamDownloaded ? messages.length : messages.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if(index == messages.length)
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );

            DocumentSnapshot message = messages[index];
            int borderState = 0;
            if (index == messages.length - 1 || messages[index + 1]['user'] != message['user']) borderState = 1;
            else if (index == 0 || messages[index - 1]['user'] != message['user']) borderState = 2;
            return ChatMessageItem(
              message: message['message'],
              time: formatDate(timestamp: message['timestamp']),
              me: message['user'] == widget.found.me,
              borderState: borderState,
            );
          },
        ),
      );
    }, fullPage: false);
  }

}
