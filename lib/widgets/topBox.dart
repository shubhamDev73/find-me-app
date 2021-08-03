import 'package:flutter/material.dart';

import 'package:findme/constant.dart';
import 'package:findme/models/appSettings.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class TopBox extends StatelessWidget {

  final double height;
  final String title;
  final String desc;
  final Widget secondaryWidget;
  final Widget widget;
  final bool settings;

  const TopBox({this.height = 210, this.title, this.secondaryWidget, this.desc = '', this.widget, this.settings = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          color: ThemeColors.boxColor,
        ),
        Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: settings ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                settings ? InkWell(
                  onTap: () {
                    List<AppSettings> settings = List.of({
                      AppSettings(text: "Change nick", onTap: () => Navigator.of(context).pushNamed('/settings/nick')),
                      aboutSettings(context),
                      privacySettings(context),
                      muteNotificationsSettings,
                      changePasswordSettings,
                      logoutSettings,
                    });

                    Navigator.of(context).pushNamed('/settings', arguments: settings);
                  },
                  child: Icon(Icons.more_vert),
                ) : InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back_ios),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 20),
            title != null ? Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ) : Container(),
            SizedBox(height: 25),
            secondaryWidget ?? Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            SizedBox(height: 22),
            widget ?? Container(),
          ],
        ),
      ],
    );
  }
}
