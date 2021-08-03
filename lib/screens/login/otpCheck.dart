import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/assets.dart';
import 'package:findme/constant.dart';
import 'package:findme/screens/loading.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class OtpCheck extends StatefulWidget {

  @override
  _OtpCheckState createState() => _OtpCheckState();
}

class _OtpCheckState extends State<OtpCheck> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading ? LoadingScreen() : Scaffold(
      body: Container(
        color: ThemeColors.primaryColor,
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
                  SizedBox(height: 8),
                  Text(
                    "find.me",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "discover so much",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: InputForm(
                fieldTypes: ['otp', 'submit'],
                submitText: 'verify OTP',
                onSubmit: (inputs) {
                  setState(() {
                    isLoading = true;
                  });

                  POST('otp/check/', {"username": globals.otpUsername, "otp": inputs['otp']}, useToken: false, callback: (json) {
                    setState(() {
                      isLoading = false;
                    });
                    if(json.containsKey('message')){
                      Navigator.of(context).pushNamed('/password/reset');
                      globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${json['message']}")));
                    }else
                      globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${json['error']}")));
                  }, onError: (String errorText) {
                    setState(() {
                      isLoading = false;
                    });
                    globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(errorText)));
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
