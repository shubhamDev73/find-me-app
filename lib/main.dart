import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:findme/screens/navigation/app.dart';
import 'package:findme/constant.dart';
import 'package:findme/models/found.dart';
import 'package:findme/models/pageTab.dart';
import 'package:findme/globals.dart' as globals;

void onNotification(Map<String, dynamic> data) async {
  switch(data['type']){
    case 'Found':
      globals.founds.get(forceNetwork: true);
      break;
    case 'Personality':
      globals.meUser.get(forceNetwork: true);
      break;
    case 'Chat':
      int id = int.parse(data['id']);
      Map<int, Found> founds = await globals.founds.get();
      globals.currentTab.set(PageTab.found);
      globals.pageOnTabChange = {"route": "/message", "arguments": founds[id]};
      break;
    case 'AvatarUpdate':
      int id = int.parse(data['id']);
      Map<String, Map<String, dynamic>> avatars = await globals.avatars.get();
      globals.founds.mappedUpdate(id, (Found found) {
        found.avatar = avatars[data['base']]![data['mood']];
        return found;
      });
      break;
    case 'NickUpdate':
      int id = int.parse(data['id']);
      globals.founds.mappedUpdate(id, (Found found) {
        found.nick = data['nick'];
        return found;
      });
      break;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  onNotification(message.data);
}

void main() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}

class Main extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ThemeColors.accentColor,
      statusBarBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primaryColor: ThemeColors.primaryColor,
        accentColor: ThemeColors.accentColor,
        highlightColor: ThemeColors.accentColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme().copyWith(
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme().copyWith(
            headline6: Theme.of(context)
                .primaryTextTheme
                .headline6!
                .copyWith(color: ThemeColors.primaryColor),
          ),
        ),
        textTheme: TextTheme(
          bodyText2: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 14.0))
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: 14.0))
        ),
      ),
      home: App(),
    );
  }
}
