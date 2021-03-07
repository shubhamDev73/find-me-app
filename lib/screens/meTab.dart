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
      '/mood': (BuildContext _) => MoodSet(me: me),
      '/interests/add': (BuildContext _) => AddInterests(),
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = createRoutes();
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) =>
          MaterialPageRoute(builder: routes[settings.name], settings: settings),
    );
  }

}
