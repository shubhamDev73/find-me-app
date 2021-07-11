import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:findme/widgets/chatListItems.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/user.dart';
import 'package:findme/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

class FoundPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<User>(globals.getUser(), (User user) =>
      createFutureWidget<Map<int, Found>>(globals.founds.get(), (Map<int, Found> founds) {
        globals.founds.get(forceNetwork: true);
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
                            child: CachedNetworkImage(
                                imageUrl: user.avatar['v1'], height: 75),
                          ),
                          Container(
                            width: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
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
          ),
        );
      }),
    );
  }
}

class ChatList extends StatefulWidget {

  final Map<int, Found> founds;
  ChatList({this.founds});

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  List<Found> foundList;

  @override
  void initState () {
    super.initState();
    assignFoundList(widget.founds);
    globals.onChatListUpdate = (Map<int, Found> founds) =>
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
        setState(() {
          assignFoundList(founds);
        })
      );
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
      DateTime aDate = DateTime.parse(a.lastMessage['timestamp']);
      DateTime bDate = DateTime.parse(b.lastMessage['timestamp']);
      return bDate.compareTo(aDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ChatListItem(
        found: foundList[index],
        index: index,
      ),
      itemCount: foundList.length,
    );
  }
}
