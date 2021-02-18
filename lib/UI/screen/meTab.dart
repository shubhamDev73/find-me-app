import 'package:flutter/material.dart';

import 'package:findme/UI/screen/home/homePage.dart';
import 'package:findme/UI/screen/profileInterestLanding/profileInterestLanding.dart';
import 'package:findme/UI/screen/profileLandingTrait/profileLandingTrait.dart';
import 'package:findme/UI/screen/profileInterestLanding/addUserInterest.dart';
import 'package:findme/UI/screen/moodSet/moodSet.dart';

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
            builder = (BuildContext _) => HomeScreen();
            break;
          case '/personality':
            builder = (BuildContext _) => ProfileLandingTrait();
            break;
          case '/interests':
            builder = (BuildContext _) => ProfileInterestLanding();
            break;
          case '/interests/add':
            builder = (BuildContext _) => AddUserInterest();
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
