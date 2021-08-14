import 'package:flutter/material.dart';

import 'package:findme/constant.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/globals.dart' as globals;

class Start extends StatefulWidget {

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {

  bool personalityDone = false;
  bool moodDone = false;
  bool interestsDone = false;

  @override
  void initState() {
    super.initState();
    globals.onboardingCallbacks['personality'] = () => setState(() {personalityDone = true;});
    globals.onboardingCallbacks['mood'] = () => setState(() {moodDone = true;});
    globals.onboardingCallbacks['interests'] = () => setState(() {interestsDone = true;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ThemeColors.accentColor,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "Let's find? Self",
                style: TextStyle(
                  fontSize: 42,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 36),
                child: Text(
                  "We want to know what you know, so we can show you what you don't know",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 36),
                child: Text(
                  "Tap on a button to continue finding self",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: Button(
                      type: 'secondary',
                      text: 'Personality',
                      fontSize: 20,
                      width: 200,
                      onTap: personalityDone ? null : () => Navigator.of(context).pushNamed('/personality'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: Button(
                      type: 'secondary',
                      text: 'Mood',
                      fontSize: 20,
                      width: 200,
                      onTap: moodDone ? null : () => Navigator.of(context).pushNamed('/mood'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: Button(
                      type: 'secondary',
                      text: 'Interests',
                      fontSize: 20,
                      width: 200,
                      onTap: interestsDone ? null : () => Navigator.of(context).pushNamed('/interests'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: personalityDone && moodDone && interestsDone ? Button(
                      text: 'Done',
                      width: 200,
                      onTap: () {
                        globals.addPostCall('onboarded/', {}, overwrite: (body) => true);
                        globals.onboarded.set(true);
                      },
                    ) : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
