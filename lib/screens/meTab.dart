import 'package:flutter/material.dart';

import 'package:findme/screens/me/profile.dart';
import 'package:findme/screens/me/interests.dart';
import 'package:findme/screens/me/personality.dart';
import 'package:findme/screens/me/addInterests.dart';
import 'package:findme/screens/me/moodSet.dart';

class MeTab extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey;
  MeTab({this.navigatorKey});

  Map<String, WidgetBuilder> createRoutes() {
    bool me = navigatorKey != null;
    return {
    '/': (BuildContext _) => Profile(me: me),
    '/personality': (BuildContext _) => Personality(me: me),
    '/interests': (BuildContext _) => Interests(me: me),
    '/interests/add': (BuildContext _) => AddInterests(),
    '/mood': (BuildContext _) => MoodSet(me: me),
    };
  }
  Map<String, WidgetBuilder> routes;

  @override
  Widget build(BuildContext context) {
    if(routes == null) routes = createRoutes();
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) =>  MaterialPageRoute(builder: routes[settings.name], settings: settings),
    );
  }

}
