import 'package:flutter/material.dart';

import 'package:findme/screens/navigation/loginScreens.dart';
import 'package:findme/screens/navigation/tabs.dart';
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
      return createFutureWidget(globals.token.get(), (String token) {
        isLoggedIn = token != '';
        return screen();
      });
    else
      return screen();
  }

  Widget screen() {
    return Scaffold(
        key: globals.scaffoldKey,
        body: isLoggedIn ? TabbedScreen() : LoginScreens(),
    );
  }
}
