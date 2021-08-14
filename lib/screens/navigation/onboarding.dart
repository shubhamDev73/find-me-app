import 'package:flutter/material.dart';

import 'package:findme/screens/navigation/animatedRoute.dart';
import 'package:findme/screens/onboarding/start.dart';
import 'package:findme/screens/onboarding/mood.dart';

class OnboardingScreens extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Map<String, Widget> createRoutes() {
    return {
      '/': Start(),
      '/mood': Mood(),
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> routes = createRoutes();
    return WillPopScope(
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) => animatedRoute(routes, settings),
      ),
    );
  }

}
