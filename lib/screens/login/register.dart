import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 60),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textFieldForRegistration(
                        editingController: emailController,
                        keyType: TextInputType.emailAddress,
                        label: "email",
                        errMsg: "please enter your email",
                        autofocus: true,
                        autofillHints: [AutofillHints.email],
                      ),
                      textFieldForRegistration(
                        editingController: phoneController,
                        keyType: TextInputType.phone,
                        label: "phone no",
                        errMsg: "please enter your phone number",
                        autofocus: true,
                        autofillHints: [AutofillHints.telephoneNumber],
                      ),
                      textFieldForRegistration(
                        editingController: usernameController,
                        keyType: TextInputType.name,
                        label: "username",
                        errMsg: "please enter your username",
                        autofillHints: [AutofillHints.email, AutofillHints.nickname, AutofillHints.name, AutofillHints.username, AutofillHints.newUsername],
                      ),
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
                                  'register',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: ThemeColors.accentColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed('/login'),
                        child: Container(
                          child: Text(
                            'login here!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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

    String email = emailController.text;
    String phone = phoneController.text;
    String username = usernameController.text;
    String password = passwordController.text;

    POST('register/', {"username": username, "email": email, "phone": phone, "password": password}, useToken: false, callback: (json) {
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

}
