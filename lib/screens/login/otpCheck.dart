import 'package:flutter/material.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/textFields.dart';
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
