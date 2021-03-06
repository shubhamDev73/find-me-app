import 'package:flutter/material.dart';

import 'package:findme/models/user.dart';
import 'package:findme/widgets/topBox.dart';
import 'package:findme/widgets/textFields.dart';
import 'package:findme/constant.dart';
import 'package:findme/screens/loading.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class ChangeNick extends StatefulWidget {

  @override
  _ChangeNickState createState() => _ChangeNickState();
}

class _ChangeNickState extends State<ChangeNick> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading ? LoadingScreen() : Scaffold(
      body: Container(
        color: ThemeColors.primaryColor,
        child: Column(
          children: [
            TopBox(title: 'Change nick'),
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 5,
              child: InputForm(
                fieldTypes: ['nick', 'submit'],
                onSubmit: (inputs) {
                  setState(() {
                    isLoading = true;
                  });

                  POST('login/details/', inputs, callback: (Map<String, dynamic>? json) {
                    setState(() {
                      isLoading = false;
                    });
                    if(json != null && json.containsKey('error'))
                      globals.showSnackBar(json['error']);
                    else{
                      globals.meUser.update((User user) {
                        user.nick = inputs['username']!;
                        return user;
                      });
                      Navigator.of(context).popUntil(ModalRoute.withName('/'));
                    }
                  }, onError: (String errorText) {
                    setState(() {
                      isLoading = false;
                    });
                    globals.showSnackBar(errorText);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
