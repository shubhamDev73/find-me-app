import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {

  final String nick;
  final String avatar;
  final String date;
  final String lastMessage;
  final int index;

  ChatList(this.nick, this.avatar, this.date, this.lastMessage, this.index);

  @override
  Widget build (BuildContext context) {
    return ColoredBox(
      color: index % 2 == 0 ? Colors.grey : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child:
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  17.0, 17.0, 17.0, 14.0),
              child: Image.network(avatar, height: 40),
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
                          nick,
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
    );
  }
}
