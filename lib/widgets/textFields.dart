import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:findme/constant.dart';
import 'package:findme/widgets/misc.dart';

Widget textFieldForRegistration({
  required TextEditingController editingController,
  TextInputType? keyType,
  bool isPhone = false,
  bool showCursor = true,
  bool readOnly = false,
  bool obscureText = false,
  bool autofocus = false,
  required String errMsg,
  required String label,
  List<String>? autofillHints,
  String? Function(String?)? validator,
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
  final bool autofocus;
  final String? Function(String?)? validator;
  PasswordField({required this.passwordController, this.label = "password", this.autofocus = false, this.validator});

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
          autofocus: widget.autofocus,
          obscureText: obscured,
          autofillHints: [AutofillHints.password],
          validator: widget.validator,
        ),
        Positioned(
          top: 25,
          right: 10,
          child: InkWell(
            onTap: () => setState(() {
              obscured = !obscured;
            }),
            child: Icon(
              obscured ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
              color: Colors.grey.shade300,
            ),
          ),
        ),
      ],
    );
  }
}

class InputForm extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> fieldTypes;
  final List<Button>? buttons;
  final String submitText;
  final Function(Map<String, String>) onSubmit;
  InputForm({required this.fieldTypes, this.buttons, this.submitText = 'submit', required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers = List.generate(fieldTypes.length, (index) => TextEditingController());
    int submitIndex = fieldTypes.indexOf('submit');
    int passwordIndex = fieldTypes.indexOf('password');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 60),
      child: Form(
        key: _formKey,
        child: Column(
          children: fieldTypes.asMap().map((index, fieldType) {
            Widget widget = Container();
            switch(fieldType){
              case 'password':
                widget = PasswordField(
                  passwordController: controllers[index],
                  autofocus: index == 0,
                );
                break;
              case 'confirmPassword':
                widget = PasswordField(
                  passwordController: controllers[index],
                  label: "confirm password",
                  autofocus: index == 0,
                  validator: (value) {
                    if(value == null || value.isEmpty || value != controllers[passwordIndex].text){
                      return "please confirm your password";
                    }
                    return null;
                  },
                );
                break;
              case 'oldPassword':
                widget = PasswordField(
                  passwordController: controllers[index],
                  label: "old password",
                  autofocus: index == 0,
                );
                break;
              case 'submit':
                widget = Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                  child: Button(
                    width: 200,
                    type: 'secondary',
                    text: submitText,
                    onTap: () {
                      int confirmPasswordIndex = fieldTypes.indexOf('confirmPassword');
                      List<String> inputFields = fieldTypes.sublist(0, confirmPasswordIndex >= 0 ? confirmPasswordIndex : submitIndex);
                      Map<String, String> inputs = Map.fromIterable(inputFields,
                        key: (fieldType) => fieldType == 'nick' ? 'username' : fieldType,
                        value: (fieldType) => controllers[fieldTypes.indexOf(fieldType)].text,
                      );
                      if(_formKey.currentState!.validate()) onSubmit(inputs);
                    },
                  ),
                );
                break;
              case 'button':
                widget = Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: buttons![index - submitIndex - 1],
                );
                break;
              case 'username':
                widget = textFieldForRegistration(
                  editingController: controllers[index],
                  keyType: TextInputType.name,
                  label: "email/phone/username",
                  errMsg: "please enter your email or phone or username",
                  autofocus: index == 0,
                  autofillHints: [AutofillHints.email, AutofillHints.telephoneNumber, AutofillHints.nickname, AutofillHints.name, AutofillHints.username],
                );
                break;
              case 'nick':
                widget = textFieldForRegistration(
                  editingController: controllers[index],
                  keyType: TextInputType.name,
                  label: "username",
                  errMsg: "please enter your username",
                  autofocus: index == 0,
                  autofillHints: [AutofillHints.nickname, AutofillHints.name, AutofillHints.username],
                );
                break;
              case 'email':
                widget = textFieldForRegistration(
                  editingController: controllers[index],
                  keyType: TextInputType.emailAddress,
                  label: "email",
                  errMsg: "please enter your email",
                  autofocus: index == 0,
                  autofillHints: [AutofillHints.email],
                );
                break;
              case 'phone':
                widget = textFieldForRegistration(
                  editingController: controllers[index],
                  keyType: TextInputType.phone,
                  label: "phone no",
                  errMsg: "please enter your phone number",
                  autofocus: index == 0,
                  autofillHints: [AutofillHints.telephoneNumber],
                );
                break;
              case 'gap':
                widget = SizedBox(height: 40);
                break;
              default:
                widget = textFieldForRegistration(
                  editingController: controllers[index],
                  keyType: TextInputType.text,
                  label: fieldType,
                  errMsg: "please enter your $fieldType",
                  autofocus: index == 0,
                );
                break;
            }
            return MapEntry(index, widget);
          }).values.toList(),
        ),
      ),
    );
  }
}
