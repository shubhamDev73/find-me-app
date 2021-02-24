import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:findme/widgets/chatItems.dart';
import 'package:findme/widgets/chatListItems.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/user.dart';
import 'package:findme/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class ChatList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    Future<User> futureUser = globals.getUser();
    Future<List<Found>> futureFound = GETResponse<List<Found>>('found/',
      decoder: (result) => result.map<Found>((found) => Found.fromJson(found)).toList(),
    );
    Future<dynamic> futureFind = GETResponse('find/');
    Future<List<dynamic>> futureRequests = GETResponse<List<dynamic>>('requests/');
    Map<String, Stream<QuerySnapshot>> lastMessages = {};
    Future<Map<String, dynamic>> futureTimes = globals.getLastReadTimes();

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                height: 150,
                color: ThemeColors.primaryColor,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: createFutureWidget<User>(futureUser, (User user) => Image.network(user.avatar, height: 75)),
                      ),
                      Container(
                        width: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Center(
                          child: createFutureWidget<List<dynamic>>(futureRequests, (requests) =>
                            createFutureWidget<dynamic>(futureFind, (find) {
                              List<dynamic> users = [...requests, ...find['users']];
                              int numRequests = requests.length;
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  dynamic user = users[index];
                                  return FindListItem(
                                    id: user['id'],
                                    avatar: user['avatar'],
                                    nick: user['nick'],
                                    isRequest: index < numRequests
                                  );
                                },
                                itemCount: users.length,
                              );
                            })
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(minHeight: 463),
                  color: Colors.white,
                  child: createFutureWidget<List<Found>>(futureFound, (foundList) =>
                    createFutureWidget<Map<String, dynamic>>(futureTimes, (times) => ListView.builder(
                      itemBuilder: (context, index) {
                        Found found = foundList[index];
                        if(!lastMessages.containsKey(found.chatId))
                          lastMessages[found.chatId] = FirebaseFirestore.instance
                            .collection('chats')
                            .doc(found.chatId)
                            .collection('chats')
                            .orderBy('timestamp', descending: true)
                            .limit(1)
                            .snapshots();

                        if(!globals.lastReadTimes.containsKey(found.chatId))
                          globals.setLastReadTimes(chatId: found.chatId, now: false);

                        return ChatListItem(
                          found: found,
                          lastMessage: lastMessages[found.chatId],
                          index: index
                        );
                      },
                      itemCount: foundList.length,
                    ))
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
