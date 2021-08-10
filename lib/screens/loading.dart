import 'package:findme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:findme/assets.dart';

class LoadingScreen extends StatelessWidget {

  final bool fullPage;
  const LoadingScreen({this.fullPage = true});

  @override
  Widget build(BuildContext context) {
    return fullPage ? Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircularProgressIndicator(),
                  Positioned(
                    bottom: 2,
                    right: -5,
                    child: Container(
                      height: 35,
                      child: SvgPicture.asset(Assets.man),
                    ),
                  ),
                ],
              ),
              Text(
                "loading content...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ThemeColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    ) :
    Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
