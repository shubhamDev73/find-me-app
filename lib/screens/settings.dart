import 'package:findme/constant.dart';
import 'package:findme/models/appSettings.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {

  final List<AppSettings> appSettings;

  const SettingsScreen({this.appSettings});

  @override
  Widget build(BuildContext context) {
    List<AppSettings> settings = appSettings ?? ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: settings.map((AppSettings setting) => InkWell(
            onTap: setting.onTap,
            child: Container(
              color: ThemeColors.chatListColors[settings.indexOf(setting) % 2 == 0],
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                setting.text
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }
}
