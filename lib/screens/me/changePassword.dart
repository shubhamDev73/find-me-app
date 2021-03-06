import 'package:flutter/material.dart';

import 'package:findme/widgets/topBox.dart';
import 'package:findme/widgets/textFields.dart';
import 'package:findme/constant.dart';
import 'package:findme/screens/loading.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class ChangePassword extends StatefulWidget {

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading ? LoadingScreen() : Scaffold(
      body: Container(
        color: ThemeColors.primaryColor,
        child: Column(
          children: [
            TopBox(title: 'Change password'),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 5,
              child: InputForm(
                fieldTypes: ['oldPassword', 'gap', 'password', 'confirmPassword', 'submit'],
                onSubmit: (inputs) {
                  setState(() {
                    isLoading = true;
                  });

                  POST('login/details/', {"old_password": inputs['oldPassword'], "password": inputs['password']}, callback: (Map<String, dynamic>? json) {
                    setState(() {
                      isLoading = false;
                    });
                    if(json != null && json.containsKey('error'))
                      globals.showSnackBar(json['error']);
                    else
                      Navigator.of(context).popUntil(ModalRoute.withName('/'));
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
