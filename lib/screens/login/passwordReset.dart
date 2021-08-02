import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:findme/widgets/textFields.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();

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
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 60),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        PasswordField(passwordController: passwordController),
                        PasswordField(
                          label: "confirm password",
                          validator: (value) {
                            if(value == null || value.isEmpty || value != passwordController.text){
                              return "please confirm your password";
                            }
                            return null;
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: RaisedButton(
                            onPressed: () {
                              if(_formKey.currentState.validate()) submitForm();
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'change password',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: ThemeColors.accentColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitForm() {

    setState(() {
      isLoading = true;
    });

    String password = passwordController.text;

    POST('password/reset/', {"username": globals.otpUsername, "password": password}, useToken: false, callback: (json) {
      setState(() {
        isLoading = false;
      });
      if(json.containsKey('message')){
        globals.otpUsername = null;
        Navigator.of(context).popUntil(ModalRoute.withName('/login'));
        globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${json['message']}")));
      }else
        globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${json['error']}")));
    }, onError: (String errorText) {
      setState(() {
        isLoading = false;
      });
      globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(errorText)));
    });

  }

}
