import 'package:flutter/material.dart';

import 'package:findme/screens/navigation/animatedRoute.dart';
import 'package:findme/screens/found/chatList.dart';
import 'package:findme/screens/found/chatMessage.dart';
import 'package:findme/screens/navigation/meTab.dart';

class FoundTab extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey;
  FoundTab({this.navigatorKey});

  final Map<String, Widget> meRoutes = MeTab().createRoutes();
  final Map<String, Widget> routes = {
    '/': FoundPage(),
    '/message': ChatMessage(),
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
      onGenerateRoute: (RouteSettings settings) => animatedRoute(routes, settings),
    );
  }
}
