import 'package:flutter/material.dart';

import 'package:findme/constant.dart';
import 'package:findme/models/appSettings.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class TopBox extends StatelessWidget {

  final String title;
  final String desc;
  final Widget widget;
  final bool settings;

  const TopBox({this.title, this.desc = '', this.widget, this.settings = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: ThemeColors.boxColor,
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: settings ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              settings ? InkWell(
                onTap: () {
                  List<AppSettings> settings = List.of({
                    AppSettings(text: "Change nick", onTap: () => globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Not implemented")))),
                    AppSettings(text: "Privacy", onTap: () => globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Not implemented")))),
                    AppSettings(text: "About", onTap: () => globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Not implemented")))),
                    AppSettings(text: "Logout", onTap: () {
                      POST('logout/', null);
                      globals.token.clear();
                    }),
                    AppSettings(text: "Mute notifications", onTap: () => globals.addPostCall('notification/token/', {"fcm_token": ""}, overwrite: (body) => true)),
                    AppSettings(text: "Change password", onTap: ()  {
                      POST('logout/', null);
                      globals.token.clear();
                    }),
                  });

                  Navigator.of(context).pushNamed('/settings', arguments: settings);
                },
                child: Icon(Icons.more_vert),
              ) : InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back_ios),
              ),
            ],
          ),
        ),
        Container(
          height: 210,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 150,
                color: ThemeColors.topBoxColor,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text(
                        desc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              widget ?? Container(),
            ],
          ),
        ),
      ],
    );
  }
}
