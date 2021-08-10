import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:findme/widgets/chatListItems.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/user.dart';
import 'package:findme/models/found.dart';
import 'package:findme/models/appSettings.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;
import 'package:findme/events.dart' as events;

class FoundPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<Map<int, Found>>(globals.founds.get(), (Map<int, Found> founds) => Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: 150,
              color: ThemeColors.primaryColor,
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 12,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          ProfilePic(),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 14,
                      child: Text(
                        "find people",
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        List<AppSettings> settings = List.of({
                          aboutSettings(context, 'found'),
                          privacySettings(context, 'found'),
                          logoutSettings('found'),
                        });

                        Navigator.of(context).pushNamed('/settings', arguments: settings);
                        events.sendEvent('settingsClick', {"page": "found"});
                      },
                      child: Icon(Icons.more_vert),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container()
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ChatList(founds: founds),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class ProfilePic extends StatefulWidget {

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {

  @override
  void initState() {
    super.initState();
    globals.onUserChanged['found'] = () => setState(() {});
  }

  @override
  void dispose() {
    globals.onUserChanged.remove('found');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<User>(globals.getUser(), (User user) =>
      CachedNetworkImage(imageUrl: user.avatar['v1'], height: 75),
    );
  }
}

class ChatList extends StatefulWidget {

  final Map<int, Found> founds;
  ChatList({required this.founds});

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  late List<Found> foundList;

  @override
  void initState () {
    super.initState();
    assignFoundList(widget.founds);
    globals.onChatListUpdate = (Map<int, Found> founds) {
      if(!mounted) return;
      setState(() {
        assignFoundList(founds);
      });
    };

    for(Found found in widget.founds.values){
      FirebaseFirestore.instance
        .collection('chats')
        .doc(found.chatId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
          List<QueryDocumentSnapshot> messages = event.docs;
          DateTime lastMessageTime = found.lastMessage == null ? DateTime.fromMillisecondsSinceEpoch(0) : DateTime.parse(found.lastMessage!['timestamp']);
          dynamic message = messages.length > 0 ? messages[0] : null;
          if(message != null && message['timestamp'] != null){
            DateTime dateTime = message['timestamp'] is String ? DateTime.parse(message['timestamp']) : message['timestamp'].toDate();
            if(dateTime.compareTo(lastMessageTime) > 0)
              globals.founds.mappedUpdate(found.id, (Found found) {
                found.lastMessage = globals.getMessageJSON(message);
                if (message['user'] != found.me)
                  found.unreadNum++;
                return found;
              });
          }
        });
    }
  }

  @override
  void dispose () {
    globals.onChatListUpdate = null;

    for(Found found in foundList)
      FirebaseDatabase.instance.reference().child("${found.id}-${found.me}").update({
        'online': false,
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
        'typing': false,
      });

    super.dispose();
  }

  void assignFoundList (Map<int, Found> founds) {
    foundList = founds.values.toList();
    foundList.sort((Found a, Found b) {
      if(a.lastMessage == null) return -1;
      if(b.lastMessage == null) return 1;
      DateTime aDate = DateTime.parse(a.lastMessage!['timestamp']);
      DateTime bDate = DateTime.parse(b.lastMessage!['timestamp']);
      return bDate.compareTo(aDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: foundList.asMap().map((index, found) => MapEntry(index, ChatListItem(
        found: found,
        index: index,
      ))).values.toList(),
    );
  }
}
