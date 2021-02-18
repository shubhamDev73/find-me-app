import 'package:flutter/material.dart';

import 'package:findme/screens/me/profile.dart';
import 'package:findme/screens/me/interests.dart';
import 'package:findme/screens/me/personality.dart';
import 'package:findme/screens/me/addInterests.dart';
import 'package:findme/screens/me/moodSet.dart';

class MeTab extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey;

  const MeTab({this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => Profile();
            break;
          case '/personality':
            builder = (BuildContext _) => Personality();
            break;
          case '/interests':
            builder = (BuildContext _) => Interests();
            break;
          case '/interests/add':
            builder = (BuildContext _) => AddInterests();
            break;
          case '/mood':
            builder = (BuildContext _) => MoodSet();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }

}
