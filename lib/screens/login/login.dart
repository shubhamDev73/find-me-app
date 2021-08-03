import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:findme/widgets/misc.dart';
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
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      POST('login/external/', {"email": account.email, "external_id": {"google": account.id}}, useToken: false, callback: (json) {
        setState(() {
          isLoading = false;
        });
        if(json.containsKey('token'))
          globals.token.set(json['token']);
        else
          globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${json['error']}")));
      }, onError: (String errorText) {
        setState(() {
          isLoading = false;
        });
        globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(errorText)));
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
              flex: 6,
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
                fieldTypes: ['username', 'password', 'submit', 'button', 'button'],
                submitText: 'login',
                buttons: [
                  Button(
                    type: 'raised',
                    text: 'forgot password',
                    onTap: () => Navigator.of(context).pushNamed('/otp/send'),
                  ),
                  Button(
                    type: 'raised',
                    text: 'login with Google',
                    onTap: () {
                      setState(() {
                        isLoading = true;
                      });
                      _googleSignIn.signIn();
                    },
                  ),
                  Button(
                    type: 'raised',
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
                    if(json.containsKey('token'))
                      globals.token.set(json['token']);
                    else
                      globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${json['error']}")));
                  }, onError: (String errorText) {
                    setState(() {
                      isLoading = false;
                    });
                    globals.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(errorText)));
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
