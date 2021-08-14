import 'package:flutter/material.dart';

import 'package:findme/screens/me/interests.dart';
import 'package:findme/constant.dart';
import 'package:findme/widgets/topBox.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/user.dart';
import 'package:findme/globals.dart' as globals;

class InterestQuestions extends StatefulWidget {

  @override
  _InterestQuestionsState createState() => _InterestQuestionsState();
}

class _InterestQuestionsState extends State<InterestQuestions> {

  int? interestId;

  @override
  Widget build(BuildContext context) {
    if (interestId == null) interestId = ModalRoute.of(context)!.settings.arguments as int;

    return createFutureWidget<User>(globals.meUser.get(), (User user) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TopBox(
              height: 190,
              title: 'Interests',
              description: 'Each interest has some questions, that you answer, that help us understand you better',
            ),
            Expanded(
              flex: 6,
              child: QuestionsWidget(me: true, interestId: interestId!, questions: user.interests[interestId]!.questions),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                'Select an interest, and you can answer the associated questions.',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                color: ThemeColors.lightColor,
                child: ThemeScrollbar(
                  child: ListView(
                    children: getInterestList(user.interests.values.toList(), (int newInterestId) => setState(() {
                      interestId = newInterestId;
                    }), interestId!),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Button(
              text: "Done",
              onTap: () {
                globals.onboardingCallbacks['interests']?.call();
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
            ),
            SizedBox(height: 15),
          ],
        ),
      );
    });
  }
}
