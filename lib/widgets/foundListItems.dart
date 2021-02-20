import 'package:flutter/material.dart';

import 'package:findme/models/found.dart';

class FoundListItem extends StatelessWidget {

  final Found found;
  final String date;
  final String lastMessage;
  final int index;

  FoundListItem({this.found, this.date = '-', this.lastMessage = '', this.index = 0});

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/message',
            arguments: found);
      },
      child: ColoredBox(
        color: index % 2 == 0 ? Colors.grey[300] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child:
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(17.0, 17.0, 17.0, 14.0),
                child: Image.network(found.avatar, height: 40),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            found.nick,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            date,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Text(
                          lastMessage,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
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
