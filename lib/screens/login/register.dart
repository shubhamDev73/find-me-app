import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/textFields.dart';
import 'package:findme/assets.dart';
import 'package:findme/constant.dart';
import 'package:findme/screens/loading.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading ? LoadingScreen() : Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          color: ThemeColors.primaryColor,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logo',
                    child: SvgPicture.asset(
                      Assets.onBoardingThree,
                      width: 60,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'find.me',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'discover so much',
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
                fieldTypes: ['email', 'phone', 'nick', 'password', 'confirmPassword', 'submit', 'button'],
                submitText: 'register',
                buttons: [
                  Button(
                    width: 200,
                    type: 'raised',
                    text: 'login here!',
                    onTap: () => Navigator.of(context).pushNamed('/login'),
                  ),
                ],
                onSubmit: (inputs) {
                  setState(() {
                    isLoading = true;
                  });

                  POST('register/', inputs, useToken: false, callback: (json) {
                    setState(() {
                      isLoading = false;
                    });
                    if(json.containsKey('token')){
                      globals.token.set(json['token']);
                      globals.userId.set(json['user_id']);
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
