import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/chatItems.dart';
import 'package:findme/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/assets.dart';
import 'package:findme/globals.dart' as globals;

class ChatMessage extends StatefulWidget {
  const ChatMessage({Key key}) : super(key: key);

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {

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
                            globals.getAnotherUser('/found/${found.id}');
                            Navigator.of(context).pushNamed('/user');
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Image.network(found.avatar, height: 75),
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

                            List<DocumentSnapshot> messages = snapshot.data.docs;
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: messages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot message = messages[index];
                                  int borderState = 0;
                                  if(index == 0 || messages[index - 1]['user'] != message['user'])
                                    borderState = 1;
                                  else if(index == messages.length - 1 || messages[index + 1]['user'] != message['user'])
                                    borderState = 2;
                                  return ChatMessageItem(
                                    message: message['message'],
                                    time: formatDate(timestamp: message['timestamp']),
                                    me: message['user'] == found.me,
                                    borderState: borderState,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }else if (snapshot.hasError) return Text("${snapshot.error}");
                      return CircularProgressIndicator();
                    },
                  ),
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
                          onSubmitted: submitChat,
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
                          submitChat(messageController.text);
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

  void submitChat (String text) {
    firestore.collection('chats').doc(found.chatId).collection('chats').add({
      'message': text,
      'user': found.me,
      'timestamp': FieldValue.serverTimestamp(),
    });
    setState(() {
      message = '';
    });
  }

}
