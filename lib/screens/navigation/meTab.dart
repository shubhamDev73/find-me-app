import 'package:flutter/material.dart';

import 'package:findme/screens/navigation/animatedRoute.dart';
import 'package:findme/screens/me/profile.dart';
import 'package:findme/screens/me/interests.dart';
import 'package:findme/screens/me/personality.dart';
import 'package:findme/screens/me/addInterests.dart';
import 'package:findme/screens/me/mood.dart';

class MeTab extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey;
  MeTab({this.navigatorKey});

  Map<String, Widget> createRoutes() {
    bool me = navigatorKey != null;
    return {
      '/': Profile(me: me),
      '/personality': Personality(me: me),
      '/interests': Interests(me: me),
      '/mood': Mood(me: me),
      '/interests/add': AddInterests(),
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> routes = createRoutes();
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) => animatedRoute(routes, settings),
    );
  }

}
