import 'package:flutter/material.dart';

import 'package:findme/constant.dart';

Widget textFieldForRegistration({
  TextEditingController editingController,
  TextInputType keyType,
  bool isPhone = false,
  bool showCursor = true,
  bool readOnly = false,
  bool obscureText = false,
  bool autofocus = false,
  String errMsg,
  String label,
}) {
  bool showHint = false;
  return TextFormField(
    autofocus: autofocus,
    maxLength: isPhone ? 10 : null,
    controller: editingController,
    keyboardType: keyType,
    obscureText: obscureText,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return errMsg;
      }
      return null;
    },
    onEditingComplete: () {
      showHint = true;
    },
    decoration: InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: ThemeColors.accentColor,
        ),
      ),
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
    ),
  );
}

class PasswordField extends StatefulWidget {

  final TextEditingController passwordController;
  PasswordField({this.passwordController});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  bool obscured = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        textFieldForRegistration(
          editingController: widget.passwordController,
          keyType: TextInputType.visiblePassword,
          label: "Password",
          errMsg: "Please enter your Password.",
          obscureText: obscured,
        ),
        Positioned(
          top: 25,
          left: 220,
          child: InkWell(
            onTap: () => setState(() {
              obscured = !obscured;
            }),
            child: Container(
              height: 20,
              width: 20,
              color: obscured ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
