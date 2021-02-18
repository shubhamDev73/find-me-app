import 'package:findme/widgets/textFields.dart';
import 'package:findme/assets.dart';
import 'package:findme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  LoginController _loginController;
  @override
  void initState() {
    _loginController = LoginController();
    _loginController.init();

    super.initState();
  }

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        textFieldForRegistration(
                            editingController:
                                _loginController.userNameController,
                            keyType: TextInputType.name,
                            label: "UserName",
                            errMsg: "Please Enter your UserName."),
                        textFieldForRegistration(
                            editingController:
                                _loginController.passwordController,
                            keyType: TextInputType.visiblePassword,
                            label: "Password",
                            errMsg: "Please Enter your Password."),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: RaisedButton(
                            onPressed: () {
                              // if (_formKey.currentState.validate())
                              //   _loginController.submitForm();

                              // if (_loginController.loading) showLoading();
                            },
                            color: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14))),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Fly',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: ThemeColors.accentColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed("/register"),
              child: Container(
                child: Text(
                  "Register here!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class LoginController {
  TextEditingController userNameController;
  TextEditingController passwordController;

  void init() {
    userNameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
  }
}
