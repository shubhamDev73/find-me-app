import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:findme/UI/Widgets/misc.dart';

class ChatMessagePage extends StatefulWidget {
  const ChatMessagePage({Key key}) : super(key: key);

  @override
  _ChatMessagePageState createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {

  Future<FirebaseApp> firebase = Firebase.initializeApp();
  String chatId;
  int me = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (chatId == null) chatId = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: createFutureWidget<FirebaseApp>(firebase, (snapshot) {
            FirebaseFirestore firestore = FirebaseFirestore.instance;
            CollectionReference chats = firestore.collection('chats');
            return createFutureWidget<QuerySnapshot>(chats.doc(chatId).collection('chats').orderBy('timestamp').get(), (snapshot) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var message = snapshot.docs[index];
                  var time = message['timestamp'].toDate();
                  return Text("${message['message']} - $time", style: TextStyle(color: message['user'] == me ? Colors.black : Colors.red));
                },
                itemCount: snapshot.docs.length,
              );
            });
          }),
        ),
      ),
    );
  }
}
