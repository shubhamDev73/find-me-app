import 'package:flutter/material.dart';

import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class AppSettings {
  AppSettings({
    this.text,
    this.onTap,
  });

  String text;
  Function onTap;
}

AppSettings privacySettings(BuildContext context){
  return AppSettings(text: "Privacy", onTap: () => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: ListTile(
        title: Text('Privacy'),
        subtitle: Text('We say everything is private on this app, but actually, nothing is private.. Mwah ha ha ha ha...'),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  ));
}

AppSettings aboutSettings(BuildContext context){
  return AppSettings(text: "About", onTap: () => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: ListTile(
        title: Text('About'),
        subtitle: Text('This app is about finding amazing conversations!!'),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  ));
}

AppSettings logoutSettings = AppSettings(text: "Logout", onTap: () {
  POST('logout/', null);
  globals.token.clear();
});

AppSettings muteNotificationsSettings = AppSettings(text: "Mute notifications", onTap: () =>
    globals.addPostCall('notification/token/', {"fcm_token": ""}, overwrite: (body) => true)
);
