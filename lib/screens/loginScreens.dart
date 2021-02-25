import 'package:flutter/material.dart';

import 'package:findme/screens/login/onBoarding.dart';
import 'package:findme/screens/login/login.dart';
import 'package:findme/screens/login/register.dart';

class LoginScreens extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKey.currentState.maybePop(),
      child: Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch(settings.name){
            case '/login':
              builder = (BuildContext _) => Login();
              break;
            case '/register':
              builder = (BuildContext _) => Register();
              break;
            case '/':
            default:
              builder = (BuildContext _) => OnBoardingScreen();
              break;
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        }
      ),
    );
  }

}
