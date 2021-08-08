import 'package:flutter/material.dart';

import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;
import 'package:findme/events.dart' as events;

class AppSettings {
  AppSettings({
    required this.text,
    required this.onTap,
  });

  String text;
  void Function() onTap;
}

AppSettings privacySettings(BuildContext context, String page){
  return AppSettings(text: "Privacy", onTap: () {
    events.sendEvent('settingsPrivacy', {"page": page});
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text('Privacy'),
          subtitle: Text('We say everything is private on this app, but actually, nothing is private..\n\nMwah ha ha ha ha...'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  });
}

AppSettings aboutSettings(BuildContext context, String page){
  return AppSettings(text: "About", onTap: () {
    events.sendEvent('settingsAbout', {"page": page});
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text('About'),
          subtitle: Text('This app is about finding amazing conversations!!'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  });
}

AppSettings logoutSettings(String page){
  return AppSettings(text: "Logout", onTap: () {
    POST('logout/', null);
    globals.token.clear();
    events.sendEvent('settingsLogout', {"page": page});
  });
}

AppSettings muteNotificationsSettings(String page) {
  return AppSettings(text: "Mute notifications", onTap: () {
    globals.addPostCall('notification/token/', {"fcm_token": ""}, overwrite: (body) => true);
    events.sendEvent('settingsMuteNotifications', {"page": page});
  });
}
