import 'package:flutter/material.dart';

import 'package:findme/screens/navigation/animatedRoute.dart';
import 'package:findme/screens/login/onBoarding.dart';
import 'package:findme/screens/login/login.dart';
import 'package:findme/screens/login/register.dart';

class LoginScreens extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final Map<String, Widget> routes = {
    '/login': Login(),
    '/register': Register(),
    '/': OnBoardingScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKey.currentState.maybePop(),
      child: Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) => animatedRoute(routes, settings),
      ),
    );
  }

}
