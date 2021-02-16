import 'package:flutter/material.dart';

import 'package:findme/UI/Widgets/chatListItems.dart';
import 'package:findme/UI/Widgets/connectListItems.dart';
import 'package:findme/UI/Widgets/misc.dart';
import 'package:findme/data/models/user.dart';
import 'package:findme/constant.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class ChatLandingPage extends StatefulWidget {
  const ChatLandingPage({Key key}) : super(key: key);

  @override
  _ChatLandingPageState createState() => _ChatLandingPageState();
}

class _ChatLandingPageState extends State<ChatLandingPage> {

  Future<dynamic> chats, connects;

  @override
  void initState() {
    super.initState();
    chats = GETResponse('found/');
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
                  child: createFutureWidget<dynamic>(chats, (data) => ListView.builder(
                    itemBuilder: (context, index) {
                      var chatItem = data[index];
                      return ChatList(chatItem['nick'], chatItem['avatar'], "11/02/2021", "last message", index);
                    },
                    itemCount: data.length,
                  )),
                ),
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 42),
                child: MenuButton('found'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
