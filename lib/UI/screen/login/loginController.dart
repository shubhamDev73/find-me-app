import 'package:flutter/cupertino.dart';

class LoginController {
  TextEditingController userNameController;
  TextEditingController passwordController;

  void init() {
    userNameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void despose() {
    userNameController.dispose();
    passwordController.dispose();
  }
}