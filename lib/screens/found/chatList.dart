import 'package:flutter/material.dart';
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
    return createFutureWidget<User>(globals.getUser(), (User user) =>
      createFutureWidget<Map<String, int>>(globals.lastReadTimes.get(), (Map<String, int> times) =>
        createFutureWidget<List<dynamic>>(GETResponse<List<dynamic>>('requests/'), (List<dynamic> requests) =>
          createFutureWidget<Map<String, dynamic>>(GETResponse<Map<String, dynamic>>('find/'), (Map<String, dynamic> find) =>
            createFutureWidget<List<Found>>(GETResponse<List<Found>>('found/',
              decoder: (result) => result.map<Found>((found) => Found.fromJson(found)).toList(),
            ), (List<Found> foundList) {
              List<dynamic> users = [...requests, ...find['users']];
              int numRequests = requests.length;
              return Scaffold(
                body: SafeArea(
                  child: Container(
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
                                  child: Image.network(user.avatar['v1'], height: 75),
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
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        dynamic user = users[index];
                                        return FindListItem(
                                            id: user['id'],
                                            avatar: user['avatar']['v1'],
                                            nick: user['nick'],
                                            isRequest: index < numRequests
                                        );
                                      },
                                      itemCount: users.length,
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
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                Found found = foundList[index];

                                if (!times.containsKey(found.chatId))
                                  globals.lastReadTimes.mappedSet(found.chatId, 0);

                                return ChatListItem(
                                  found: found,
                                  lastMessage: FirebaseFirestore.instance
                                      .collection('chats')
                                      .doc(found.chatId)
                                      .collection('chats')
                                      .orderBy(
                                      'timestamp', descending: true)
                                      .limit(1)
                                      .snapshots(),
                                  index: index
                                );
                              },
                              itemCount: foundList.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
