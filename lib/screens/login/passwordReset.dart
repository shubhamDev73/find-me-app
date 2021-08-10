import 'package:flutter/material.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/textFields.dart';
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
              flex: 2,
              child: Button(type: 'back'),
            ),
            Expanded(
              flex: 2,
              child: Container(),
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
                      globals.showSnackBar(json['message']);
                    }else
                      globals.showSnackBar(json['error']);
                  }, onError: (String errorText) {
                    setState(() {
                      isLoading = false;
                    });
                    globals.showSnackBar(errorText);
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
