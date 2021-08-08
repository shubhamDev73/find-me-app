import 'package:flutter/material.dart';

import 'package:findme/constant.dart';
import 'package:findme/models/appSettings.dart';
import 'package:findme/widgets/misc.dart';

class SettingsScreen extends StatelessWidget {

  final List<AppSettings>? appSettings;

  const SettingsScreen({this.appSettings});

  @override
  Widget build(BuildContext context) {
    List<AppSettings> settings = appSettings ?? ModalRoute.of(context)!.settings.arguments as List<AppSettings>;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Button(type: 'back'),
          ),
          Expanded(
            flex: 15,
            child: ListView(
              children: settings.map((AppSettings setting) => InkWell(
                onTap: setting.onTap,
                child: Container(
                  color: ThemeColors.interestColors[1 - settings.indexOf(setting) % 2],
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    setting.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
