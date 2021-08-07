import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/assets.dart';
import 'package:findme/constant.dart';
import 'package:findme/screens/loading.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class PasswordReset extends StatefulWidget {

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {

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
                fieldTypes: ['password', 'confirmPassword', 'submit'],
                submitText: 'change password',
                onSubmit: (inputs) {
                  setState(() {
                    isLoading = true;
                  });

                  POST('password/reset/', {"username": globals.otpUsername, "password": inputs['password']}, useToken: false, callback: (json) {
                    setState(() {
                      isLoading = false;
                    });
                    if(json.containsKey('message')){
                      globals.otpUsername = '';
                      Navigator.of(context).popUntil(ModalRoute.withName('/login'));
                      globals.scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("${json['message']}")));
                    }else
                      globals.scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("${json['error']}")));
                  }, onError: (String errorText) {
                    setState(() {
                      isLoading = false;
                    });
                    globals.scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(errorText)));
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
