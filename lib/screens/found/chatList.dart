import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:findme/widgets/chatItems.dart';
import 'package:findme/widgets/chatListItems.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/user.dart';
import 'package:findme/models/found.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

class FoundPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    globals.requests.get();
    globals.finds.get();
    globals.founds.get();
    return createFutureWidget<User>(globals.getUser(), (User user) =>
      createFutureWidget<List<dynamic>>(globals.requests.get(), (List<dynamic> requests) =>
        createFutureWidget<List<dynamic>>(globals.finds.get(), (List<dynamic> finds) =>
          createFutureWidget<Map<int, Found>>(globals.founds.get(), (Map<int, Found> founds) {
            globals.requests.get(forceNetwork: true);
            globals.finds.get(forceNetwork: true);
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
                              Expanded(
                                flex: 7,
                                child: Center(
                                  child: FindList(),
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
        ),
      ),
    );
  }
}

class FindList extends StatefulWidget {

  @override
  _FindListState createState() => _FindListState();
}

class _FindListState extends State<FindList> {

  @override
  void initState(){
    super.initState();
    globals.onFindsUpdate = () => setState(() {});
  }

  @override
  void dispose(){
    globals.onFindsUpdate = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<List<dynamic>>(globals.requests.get(), (List<dynamic> requests) =>
      createFutureWidget<List<dynamic>>(globals.finds.get(), (List<dynamic> finds) {
        List<dynamic> users = [...requests, ...finds];
        int numRequests = requests.length;
        return ListView.builder(
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
        );
      }, fullPage: false),
      fullPage: false,
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
