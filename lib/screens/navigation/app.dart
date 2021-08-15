import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:findme/models/found.dart';
import 'package:findme/models/pageTab.dart';
import 'package:findme/screens/navigation/loginScreens.dart';
import 'package:findme/screens/navigation/tabs.dart';
import 'package:findme/screens/navigation/onboarding.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/globals.dart' as globals;

void onNotification(Map<String, dynamic> data) async {
  switch(data['type']){
    case 'Found':
      globals.founds.get(forceNetwork: true);
      globals.pageOnTabChange = {"tab": PageTab.found, "route": "/"};
      break;
    case 'Personality':
      await globals.meUser.get(forceNetwork: true);
      bool onboarded = await globals.onboarded.get();
      globals.pageOnTabChange = onboarded ? {"tab": PageTab.me, "route": "/personality", "arguments": "Water"} : {"route": "/personality/bar"};
      break;
    case 'Chat':
      int id = int.parse(data['id']);
      Map<int, Found> founds = await globals.founds.get();
      globals.pageOnTabChange = {"tab": PageTab.found, "route": "/message", "arguments": founds[id]};
      break;
    case 'AvatarUpdate':
      int id = int.parse(data['id']);
      Map<String, Map<String, dynamic>> avatars = await globals.avatars.get();
      globals.founds.mappedUpdate(id, (Found found) {
        found.mood = data['mood'];
        found.avatar = avatars[data['base']]!['avatars'][data['mood']]['url'];
        return found;
      });
      if(globals.otherUserId == data['id']) globals.otherUser.clear();
      break;
    case 'NickUpdate':
      int id = int.parse(data['id']);
      globals.founds.mappedUpdate(id, (Found found) {
        found.nick = data['nick'];
        return found;
      });
      if(globals.otherUserId == data['id']) globals.otherUser.clear();
      break;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  onNotification(message.data);
}

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

  void getData() async {
    // user data
    globals.meUser.get(forceNetwork: true);
    globals.founds.get(forceNetwork: true);

    // info data
    globals.interests.get(forceNetwork: true);
    globals.moods.get(forceNetwork: true);
    globals.avatars.get(forceNetwork: true);
    globals.personality.get(forceNetwork: true);

    // firebase
    await Firebase.initializeApp();

    // notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    String fcmToken = (await FirebaseMessaging.instance.getToken())!;
    globals.addPostCall('notification/token/', {"fcm_token": fcmToken}, overwrite: (body) => true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if(message.data['type'] != 'Chat') onNotification(message.data);

      bool display = true;
      if(message.data.containsKey('display')) display = message.data['display'] == 'true';

      if(display && message.notification != null){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message.notification!.title!),
              subtitle: Text(message.notification!.body!),
            ),
            actions: [
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    });
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
