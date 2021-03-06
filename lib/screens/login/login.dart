import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/textFields.dart';
import 'package:findme/assets.dart';
import 'package:findme/constant.dart';
import 'package:findme/screens/loading.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if(account == null){
        globals.showSnackBar('Something went wrong.');
        return;
      }

      POST('login/external/', {"email": account.email, "external_id": {"google": account.id}}, useToken: false, callback: (json) {
        setState(() {
          isLoading = false;
        });
        if(json.containsKey('token')){
          if(json.remove('created')){
            globals.tempExternalRegister.addAll(json);
            Navigator.of(context).pushNamed('/extra');
          }else{
            globals.token.set(json['token']);
            globals.userId.set(json['user_id']);
            globals.onboarded.set(json['onboarded']);
          }
        }else
          globals.showSnackBar(json['error']);
      }, onError: (String errorText) {
        setState(() {
          isLoading = false;
        });
        globals.showSnackBar(errorText);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? LoadingScreen() : Scaffold(
      body: Container(
        color: ThemeColors.primaryColor,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logo',
                    child: SvgPicture.asset(
                      Assets.onboardingThree,
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
                fieldTypes: ['username', 'password', 'submit', 'button', 'button', 'button'],
                submitText: 'login',
                buttons: [
                  Button(
                    width: 200,
                    type: 'secondary',
                    text: 'forgot password',
                    onTap: () => Navigator.of(context).pushNamed('/otp/send'),
                  ),
                  Button(
                    width: 200,
                    type: 'secondary',
                    text: 'login with Google',
                    onTap: () {
                      setState(() {
                        isLoading = true;
                      });
                      _googleSignIn.signIn();
                    },
                  ),
                  Button(
                    width: 200,
                    type: 'secondary',
                    text: 'register here!',
                    onTap: () => Navigator.of(context).pushNamed('/register'),
                  ),
                ],
                onSubmit: (inputs) {
                  setState(() {
                    isLoading = true;
                  });

                  POST('login/', inputs, useToken: false, callback: (json) {
                    setState(() {
                      isLoading = false;
                    });
                    if(json.containsKey('token')){
                      globals.token.set(json['token']);
                      globals.userId.set(json['user_id']);
                      globals.onboarded.set(json['onboarded']);
                    }else
                      globals.showSnackBar(json['error']);
                  }, onError: (String errorText) {
                    setState(() {
                      isLoading = false;
                    });
                    globals.showSnackBar(errorText);
                  });
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
