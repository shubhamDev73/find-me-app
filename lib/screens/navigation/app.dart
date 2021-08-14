import 'package:flutter/material.dart';

import 'package:findme/screens/navigation/loginScreens.dart';
import 'package:findme/screens/navigation/tabs.dart';
import 'package:findme/screens/navigation/onboarding.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/globals.dart' as globals;

class App extends StatefulWidget {

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  bool? isLoggedIn;
  bool? isOnboarded;

  @override
  void initState () {
    super.initState();
    getPosts();
    globals.onLogout = () => setState(() {
      isLoggedIn = false;
    });
    globals.onLogin = () => setState(() {
      getData();
      isLoggedIn = true;
    });
    globals.onOnboarded = (bool onboarded) => setState(() {
      isOnboarded = onboarded;
    });
  }

  void getData() {
    // user data
    globals.meUser.get(forceNetwork: true);
    globals.founds.get(forceNetwork: true);

    // info data
    globals.interests.get(forceNetwork: true);
    globals.moods.get(forceNetwork: true);
    globals.avatars.get(forceNetwork: true);
    globals.personality.get(forceNetwork: true);
  }

  void getPosts() async {
    await globals.posts.get();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoggedIn == null || isOnboarded == null)
      return createFutureWidget(globals.token.get(), (String token) => createFutureWidget(globals.onboarded.get(), (bool onboarded) {
        isOnboarded = onboarded;
        isLoggedIn = token != '';
        if(isLoggedIn!) getData();
        return screen();
      }));
    else
      return screen();
  }

  Widget screen() {
    return isLoggedIn! ? isOnboarded! ? TabbedScreen() : OnboardingScreens() : LoginScreens();
  }
}
