import 'package:flutter/material.dart';

import 'package:findme/screens/found/chatList.dart';
import 'package:findme/screens/found/chatMessage.dart';

class FoundTab extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey;

  const FoundTab({this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => ChatList();
            break;
          case '/message':
            builder = (BuildContext _) => ChatMessage();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
