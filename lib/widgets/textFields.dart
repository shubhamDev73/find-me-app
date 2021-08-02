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
  List<String> autofillHints,
  Function(String) validator,
}) {
  return TextFormField(
    autofocus: autofocus,
    maxLength: isPhone ? 10 : null,
    controller: editingController,
    keyboardType: keyType,
    obscureText: obscureText,
    autofillHints: autofillHints,
    validator: validator ?? (value) {
      if (value == null || value.isEmpty) {
        return errMsg;
      }
      return null;
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
  final String label;
  final Function(String) validator;
  PasswordField({this.passwordController, this.label = "password", this.validator});

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
          label: widget.label,
          errMsg: "please enter your password",
          obscureText: obscured,
          autofillHints: [AutofillHints.password],
          validator: widget.validator,
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
