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
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 10,
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
          ],
        ),
      ),
    );
  }
}
