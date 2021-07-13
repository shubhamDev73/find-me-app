import 'package:flutter/material.dart';

import 'package:findme/constant.dart';

class TopBox extends StatelessWidget {

  final String title;
  final String desc;
  final Widget widget;

  const TopBox({this.title, this.desc = '', this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: ThemeColors.boxColor,
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.more_vert),
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
