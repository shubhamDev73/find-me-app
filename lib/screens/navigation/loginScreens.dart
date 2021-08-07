import 'package:flutter/material.dart';

import 'package:findme/screens/navigation/animatedRoute.dart';
import 'package:findme/screens/login/onboarding.dart';
import 'package:findme/screens/login/login.dart';
import 'package:findme/screens/login/extra.dart';
import 'package:findme/screens/login/register.dart';
import 'package:findme/screens/login/otpSend.dart';
import 'package:findme/screens/login/otpCheck.dart';
import 'package:findme/screens/login/passwordReset.dart';

class LoginScreens extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final Map<String, Widget> routes = {
    '/': OnboardingScreens(),
    '/login': Login(),
    '/extra': Extra(),
    '/register': Register(),
    '/otp/send': OtpSend(),
    '/otp/check': OtpCheck(),
    '/password/reset': PasswordReset(),
  };

  @override
  Widget build(BuildContext context) {
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
