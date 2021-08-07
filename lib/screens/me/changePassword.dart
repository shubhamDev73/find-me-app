import 'package:flutter/material.dart';

import 'package:findme/widgets/topBox.dart';
import 'package:findme/widgets/misc.dart';
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
              flex: 5,
              child: InputForm(
                fieldTypes: ['password', 'confirmPassword', 'submit'],
                onSubmit: (inputs) {
                  setState(() {
                    isLoading = true;
                  });

                  POST('login/details/', inputs, callback: (json) {
                    setState(() {
                      isLoading = false;
                    });
                    if(json.containsKey('error'))
                      globals.scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("${json['error']}")));
                    else{
                      Navigator.of(context).popUntil(ModalRoute.withName('/'));
                    }
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
