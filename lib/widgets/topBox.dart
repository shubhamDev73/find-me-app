import 'package:flutter/material.dart';

import 'package:findme/constant.dart';
import 'package:findme/models/appSettings.dart';
import 'package:findme/events.dart' as events;

class TopBox extends StatelessWidget {

  final double height;
  final String? title;
  final String description;
  final Widget? secondaryWidget;
  final Widget? widget;
  final bool settings;

  const TopBox({this.height = 210, this.title, this.secondaryWidget, this.description = '', this.widget, this.settings = false});

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
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: settings ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                SizedBox(width: 12),
                settings ? InkWell(
                  onTap: () {
                    List<AppSettings> settings = List.of({
                      AppSettings(text: "Change nick", onTap: () {
                        Navigator.of(context).pushNamed('/settings/nick');
                        events.sendEvent('settingsChangeNick');
                      }),
                      aboutSettings(context, 'me'),
                      privacySettings(context, 'me'),
                      muteNotificationsSettings('me'),
                      AppSettings(text: "Change password", onTap: () {
                        Navigator.of(context).pushNamed('/settings/password');
                        events.sendEvent('settingsChangePassword');
                      }),
                      logoutSettings('me'),
                    });

                    Navigator.of(context).pushNamed('/settings', arguments: settings);
                    events.sendEvent('settingsClick', {"page": "me"});
                  },
                  child: Icon(Icons.more_vert),
                ) : InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back_ios),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 10),
            title != null ? Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ) : Container(),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              child: secondaryWidget ?? Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            SizedBox(height: 10),
            widget ?? Container(),
          ],
        ),
      ],
    );
  }
}
