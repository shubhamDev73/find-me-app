import 'package:flutter/material.dart';

import 'package:findme/constant.dart';

Widget textFieldForRegistration({
  TextEditingController editingController,
  TextInputType keyType,
  bool isPhone = false,
  bool showCursor = true,
  bool readOnly = false,
  bool obscureText = false,
  String errMsg,
  String label,
}) {
  bool showHint = false;
  return TextFormField(
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
