import 'package:flutter/material.dart';

import 'package:findme/screens/navigation/animatedRoute.dart';
import 'package:findme/screens/onboarding/start.dart';
import 'package:findme/screens/onboarding/personality.dart';
import 'package:findme/screens/onboarding/personalityElements.dart';
import 'package:findme/screens/onboarding/personalityBar.dart';
import 'package:findme/screens/onboarding/personalityAdjectives.dart';
import 'package:findme/screens/onboarding/mood.dart';
import 'package:findme/screens/onboarding/interests.dart';
import 'package:findme/screens/onboarding/addInterests.dart';
import 'package:findme/screens/onboarding/interestQuestions.dart';

class OnboardingScreens extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Map<String, Widget> createRoutes() {
    return {
      '/': Start(),
      '/personality': Personality(),
      '/personality/elements': PersonalityElements(),
      '/personality/bar': PersonalityBar(),
      '/personality/adjectives': PersonalityAdjectives(),
      '/mood': Mood(),
      '/interests': Interests(),
      '/interests/add': AddInterests(),
      '/interests/question': InterestQuestions(),
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
