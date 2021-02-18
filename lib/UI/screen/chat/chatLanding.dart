import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:findme/UI/Widgets/chatListItems.dart';
import 'package:findme/UI/Widgets/connectListItems.dart';
import 'package:findme/UI/Widgets/misc.dart';
import 'package:findme/data/models/user.dart';
import 'package:findme/data/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class ChatLandingPage extends StatefulWidget {
  const ChatLandingPage({Key key}) : super(key: key);

  @override
  _ChatLandingPageState createState() => _ChatLandingPageState();
}

class _ChatLandingPageState extends State<ChatLandingPage> {

  Future<List<Found>> futureFound;
  Future<dynamic> connects;

  @override
  void initState() {
    super.initState();
    futureFound = GETResponse<List<Found>>('found/',
      decoder: (result) => result.map<Found>((found) => Found.fromJson(found)).toList(),
    );
    connects = GETResponse('find/');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          // color: Colors.pink,
          child: Column(
            children: [
              Container(
                height: 125,
                color: ThemeColors.primaryColor,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                        child: createFutureWidget<User>(globals.futureUser, (User user) => Image.network(user.avatar, height: 75)),
                      ),
                      Container(
                          width: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          )
                      ),
                      Container(
                        width: 250,
                        child: createFutureWidget<dynamic>(connects, (data) => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return ConnectList(data['users'][index]['avatar']);
                          },
                          itemCount: data['users'].length,
                        )),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(minHeight: 463),
                  color: Colors.white,
                  child: FutureBuilder<FirebaseApp>(
                    future: Firebase.initializeApp(),
                    builder: (context, snapshot) {
                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                      if (snapshot.connectionState == ConnectionState.done) {
                        return createFutureWidget<List<Found>>(futureFound, (foundList) => ListView.builder(
                          itemBuilder: (context, index) {
                            Found foundItem = foundList[index];
                            Future<QuerySnapshot> lastMessage = firestore.collection('chats').doc(foundItem.chatId).collection('chats').orderBy('timestamp', descending: true).limit(1).get();
                            return createFutureWidget<QuerySnapshot>(lastMessage, (QuerySnapshot message) => ChatList(
                                found: foundItem,
                                date: "${message.docs[0]['timestamp'].toDate()}",
                                lastMessage: message.docs[0]['message'],
                                index: index
                              ));
                          },
                          itemCount: foundList.length,
                        ));
                      }
                      return CircularProgressIndicator();
                    }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
