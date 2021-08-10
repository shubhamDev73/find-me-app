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

  bool? isLoggedIn;

  @override
  void initState () {
    super.initState();
    init();
    globals.onLogout = () => setState(() {
      isLoggedIn = false;
    });
    globals.onLogin = () => setState(() {
      init();
      isLoggedIn = true;
    });
  }

  void init() async {
    // user data
    globals.meUser.get(forceNetwork: true);
    globals.founds.get(forceNetwork: true);

    // info data
    globals.interests.get(forceNetwork: true);
    globals.moods.get(forceNetwork: true);
    globals.avatars.get(forceNetwork: true);
    globals.personality.get(forceNetwork: true);

    await globals.posts.get();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoggedIn == null)
      return createFutureWidget(globals.token.get(), (String token) {
        isLoggedIn = token != '';
        if(isLoggedIn!) init();
        return screen();
      });
    else
      return screen();
  }

  Widget screen() {
    return isLoggedIn! ? TabbedScreen() : LoginScreens();
  }
}
