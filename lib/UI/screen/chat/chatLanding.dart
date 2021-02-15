import 'package:findme/UI/Widgets/menuButton.dart';
import 'package:flutter/material.dart';

class ChatItemModel {
  String name;
  String mostRecentMessage;
  String messageDate;
  int unreadMessageCount;

  ChatItemModel(this.name, this.mostRecentMessage, this.messageDate,
      this.unreadMessageCount);
}

class ChatHelper {
  static var chatList = [
    ChatItemModel("Alice", "Lunch in the evening?", "16/07/2018", 2),
    ChatItemModel("Jack", "Sure", "16/07/2018", 3),
    ChatItemModel("Jane", "Meet this week?", "16/07/2018", 4),
    ChatItemModel("Ned", "Received!", "16/07/2018", 5),
    ChatItemModel("Steve", "I'll come too!", "16/07/2018", 1),
    ChatItemModel("Alice", "Lunch in the evening?", "16/07/2018", 1),
    ChatItemModel("Jack", "Sure", "16/07/2018", 1),
    ChatItemModel("Jane", "Meet this week?", "16/07/2018", 1),
    ChatItemModel("Ned", "Received!", "16/07/2018", 1),
    ChatItemModel("Steve", "I'll come too!", "16/07/2018", 8),
    ChatItemModel("Alice", "Lunch in the evening?", "16/07/2018", 1),
    ChatItemModel("Jack", "Sure", "16/07/2018", 99),
    ChatItemModel("Jane", "Meet this week?", "16/07/2018", 100),
    ChatItemModel("Ned", "Received!", "16/07/2018", 100),
  ];

  static ChatItemModel getChatItem(int position) {
    return chatList[position];
  }

  static var itemCount = chatList.length;
}

class ChatLandingPage extends StatelessWidget {
  const ChatLandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          // color: Colors.pink,
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 125),
                color: Colors.yellow,
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(minHeight: 463),
                  color: Colors.white,
                  child: ListView.builder(
                    itemBuilder: (context, position) {
                      ChatItemModel chatItem = ChatHelper.getChatItem(position);
                      return ColoredBox(
                        color: position % 2 == 0 ? Colors.grey : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    17.0, 17.0, 17.0, 14.0),
                                child: Icon(
                                  Icons.account_circle,
                                  size: 40,
                                ),
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
                                            chatItem.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20.0),
                                          ),
                                          Text(
                                            chatItem.messageDate,
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          chatItem.mostRecentMessage,
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
                    },
                    itemCount: ChatHelper.itemCount,
                  ),
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
