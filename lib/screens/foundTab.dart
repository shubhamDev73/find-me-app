import 'package:flutter/material.dart';

import 'package:findme/screens/found/chatList.dart';
import 'package:findme/screens/found/chatMessage.dart';
import 'package:findme/screens/meTab.dart';

class FoundTab extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey;
  FoundTab({this.navigatorKey});

  final Map<String, WidgetBuilder> meRoutes = MeTab().createRoutes();
  final Map<String, WidgetBuilder> routes = {
    '/': (BuildContext _) => ChatList(),
    '/message': (BuildContext _) => ChatMessage(),
  };

  @override
  Widget build(BuildContext context) {
    if(!routes.containsKey('/user')){
      routes['/user'] = meRoutes.remove('/');
      routes.addAll(meRoutes);
    }
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(builder: routes[settings.name], settings: settings),
    );
  }
}
