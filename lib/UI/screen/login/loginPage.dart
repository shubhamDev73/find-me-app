import 'package:findme/configs/assets.dart';
import 'package:findme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(color: MyColors().primaryColor
          // gradient: new LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Colors.white,
          //     MyColors().primaryColor,
          //   ],
          // ),
          ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: "logo",
                  child: SvgPicture.asset(
                    Assets.onBoardingThree,
                    width: 60,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "find.me",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                Text(
                  "discover so much",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 60),
              child: Form(
                  key: key,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "email:",
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(),
          )
        ],
      ),
    ));
  }
}
