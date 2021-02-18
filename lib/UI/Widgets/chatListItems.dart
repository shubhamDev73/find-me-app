import 'package:flutter/material.dart';

import 'package:findme/data/models/found.dart';

class ChatList extends StatelessWidget {

  final Found found;
  final String date;
  final String lastMessage;
  final int index;

  ChatList({this.found, this.date = '-', this.lastMessage = '', this.index = 0});

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/chatMessage',
            arguments: found);
      },
      child: ColoredBox(
        color: index % 2 == 0 ? Colors.grey : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child:
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    17.0, 17.0, 17.0, 14.0),
                child: Image.network(found.avatar, height: 40),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            found.nick,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0),
                          ),
                          Text(
                            date,
                            style: TextStyle(
                                color: Colors.black45),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 2.0),
                        child: Text(
                          lastMessage,
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 16.0),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
