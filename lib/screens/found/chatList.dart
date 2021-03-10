import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:findme/widgets/chatItems.dart';
import 'package:findme/widgets/chatListItems.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/user.dart';
import 'package:findme/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

class ChatList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<User>(globals.getUser(), (User user) =>
      createFutureWidget<Map<String, int>>(globals.lastReadTimes.get(), (Map<String, int> times) =>
        createFutureWidget<List<dynamic>>(globals.requests.get(), (List<dynamic> requests) =>
          createFutureWidget<List<dynamic>>(globals.finds.get(), (List<dynamic> finds) =>
            createFutureWidget<List<Found>>(globals.founds.get(), (List<Found> founds) {
              List<dynamic> users = [...requests, ...finds];
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
                                Found found = founds[index];

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
                              itemCount: founds.length,
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
