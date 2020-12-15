import 'package:flutter/cupertino.dart';

class RegisterController {
  TextEditingController userNameController;
  TextEditingController passwordController;
  TextEditingController phoneController;

  void init() {
    userNameController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
  }

  void despose() {
    userNameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
  }
}
