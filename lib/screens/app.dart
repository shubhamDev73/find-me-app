import 'package:flutter/material.dart';

import 'package:findme/screens/loginScreens.dart';
import 'package:findme/screens/tabs.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/globals.dart' as globals;

class App extends StatefulWidget {

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  bool isLoggedIn;

  @override
  void initState () {
    super.initState();
    globals.onLogout = () {setState(() {
      isLoggedIn = false;
    });};
    globals.onLogin = () {setState(() {
      isLoggedIn = true;
    });};
  }

  @override
  Widget build(BuildContext context) {
    if(isLoggedIn == null)
      return createFutureWidget(globals.getToken(), (String token) {
        isLoggedIn = token != '';
        return isLoggedIn ? TabbedScreen() : LoginScreens();
      });
    else
      return isLoggedIn ? TabbedScreen() : LoginScreens();
  }
}
