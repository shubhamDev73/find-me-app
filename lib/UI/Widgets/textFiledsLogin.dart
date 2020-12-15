import 'package:findme/constant.dart';
import 'package:flutter/material.dart';

Widget textFieldForRegistration({
  TextEditingController editingController,
  TextInputType keyType,
  bool isPhone = false,
  bool showCursor = true,
  bool readOnly = false,
  String errMsg,
  String label,
}) {
  bool showHint = false;
  return TextFormField(
    maxLength: isPhone ? 10 : null,
    controller: editingController,
    keyboardType: keyType,
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
        hintText: label,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: MyColors.accentColor,
          ),
        ),
        labelText: label,
        helperStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white)),
  );
}
