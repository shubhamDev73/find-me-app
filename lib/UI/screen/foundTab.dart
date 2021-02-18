import 'package:flutter/material.dart';

import 'package:findme/UI/screen/chat/chatLanding.dart';
import 'package:findme/UI/screen/chat/chatMessage.dart';

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
            builder = (BuildContext _) => ChatLandingPage();
            break;
          case '/message':
            builder = (BuildContext _) => ChatMessagePage();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
