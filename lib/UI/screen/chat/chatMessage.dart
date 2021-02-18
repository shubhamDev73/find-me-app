import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';

import 'package:findme/UI/Widgets/misc.dart';
import 'package:findme/data/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

class ChatMessagePage extends StatefulWidget {
  const ChatMessagePage({Key key}) : super(key: key);

  @override
  _ChatMessagePageState createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {

  FirebaseFirestore firestore;
  Found found;
  String message = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (found == null) found = ModalRoute.of(context).settings.arguments as Found;

    TextEditingController messageController = new TextEditingController(text: message);

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 125,
                width: 500,
                color: ThemeColors.primaryColor,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                        child: Image.network(found.avatar, height: 75),
                      ),
                      Container(
                        height: 27,
                        child: Text(found.nick),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 300,
                child: FutureBuilder<FirebaseApp>(
                    future: Firebase.initializeApp(),
                    builder: (context, snapshot) {
                      firestore = FirebaseFirestore.instance;
                      if(snapshot.connectionState == ConnectionState.done){
                        CollectionReference chats = firestore.collection('chats');
                        return StreamBuilder<QuerySnapshot>(
                          stream: chats.doc(found.chatId).collection('chats').orderBy('timestamp').limit(50).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading");
                            }

                            ScrollController scrollController = ScrollController();
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              scrollController.jumpTo(scrollController.position.maxScrollExtent);
                            });

                            return new ListView(
                              controller: scrollController,
                              children: snapshot.data.docs.map((DocumentSnapshot message) {
                                var time = message['timestamp'].toDate();
                                return Container(
                                  decoration: BoxDecoration(
                                    color: message['user'] == found.me ? ThemeColors.lightColor : ThemeColors.primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                  child: Text("${message['message']} - $time"),
                                );
                              }).toList(),
                            );
                          },
                        );
                      }else if (snapshot.hasError) return Text("${snapshot.error}");
                      return CircularProgressIndicator();
                    },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                child: TextField(
                  controller: messageController,
                  onSubmitted: (text) {
                    firestore.collection('chats').doc(found.chatId).collection('chats').add({
                      'message': text,
                      'user': found.me,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    setState(() {
                      message = '';
                    });
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
