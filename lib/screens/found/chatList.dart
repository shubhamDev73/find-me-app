import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:findme/widgets/foundListItems.dart';
import 'package:findme/widgets/findListItems.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/user.dart';
import 'package:findme/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class ChatList extends StatefulWidget {
  const ChatList({Key key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  Future<User> futureUser;
  Future<List<Found>> futureFound;
  Future<dynamic> connects;

  @override
  void initState() {
    super.initState();
    futureUser = globals.getUser();
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
                        child: createFutureWidget<User>(futureUser, (User user) => Image.network(user.avatar, height: 75)),
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
                            dynamic user = data['users'][index];
                            return FindListItem(id: user['id'], avatar: user['avatar']);
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
                            return createFutureWidget<QuerySnapshot>(lastMessage, (QuerySnapshot message) => FoundListItem(
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
