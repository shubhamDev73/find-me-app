import 'dart:convert';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: isLoading ? LoadingScreen(fullPage: false) : Container(
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
                  tag: "logo",
                  child: SvgPicture.asset(
                    Assets.onBoardingThree,
                    width: 60,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "find.me",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                Text(
                  "discover so much",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
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
                        editingController: usernameController,
                        keyType: TextInputType.name,
                        label: "UserName",
                        errMsg: "Please enter your Username.",
                        autofocus: true,
                      ),
                      textFieldForRegistration(
                        editingController: phoneController,
                        keyType: TextInputType.number,
                        isPhone: true,
                        label: "Phone",
                        errMsg: "Please enter your Phone.",
                      ),
                      PasswordField(passwordController: passwordController),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: RaisedButton(
                          onPressed: () {
                             if (_formKey.currentState.validate())
                               submitForm(_scaffoldKey);
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
                                  'Register',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: ThemeColors.accentColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed("/login"),
              child: Container(
                child: Text(
                  "Login here!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  void submitForm (GlobalKey<ScaffoldState> scaffoldKey) async {

    setState(() {
      isLoading = true;
    });

    String username = usernameController.text;
    String password = passwordController.text;

    final response = await POST('register/', jsonEncode({"username": username, "password": password}), useToken: false);

    setState(() {
      isLoading = false;
    });

    Map<String, dynamic> json = jsonDecode(response.body);
    if (response.statusCode == 200 && json.containsKey('token'))
      globals.token.set(json['token']);
    else
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${json['error']}")));
  }

}
