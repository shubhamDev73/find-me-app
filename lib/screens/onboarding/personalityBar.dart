import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/traitBar.dart';
import 'package:findme/widgets/topBox.dart';
import 'package:findme/assets.dart';
import 'package:findme/models/user.dart';
import 'package:findme/globals.dart' as globals;

class PersonalityBar extends StatefulWidget {

  @override
  _PersonalityBarState createState() => _PersonalityBarState();
}

class _PersonalityBarState extends State<PersonalityBar> {

  String trait = 'Water';

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<User>(globals.meUser.get(), (User user) =>
      createFutureWidget<Map<String, Map<String, dynamic>>>(globals.personality.get(), (Map<String, Map<String, dynamic>> personality) => Scaffold(
        body: Column(
          children: [
            TopBox(
              description: "Here is your first analysis for various elements.",
              height: 190,
              widget: TraitsElements(
                onClick: (String traitString) => setState(() {trait = traitString;}),
                personality: user.personality,
                selectedElement: trait,
              ),
            ),
            SizedBox(height: 40),
            Container(
              child: Center(
                child: Text(
                  trait,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 25),
              child: Text(
                user.personality[trait]['description'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  height: 30,
                  width: 50,
                  child: SvgPicture.asset(Assets.traits[trait]!['negative']!),
                ),
                Container(
                  width: 220,
                  height: 30,
                  child: Stack(
                    children: [
                      Positioned(
                        left: ((user.personality[trait]['value'] + 1) / 2) * (305 - 90) - 305, // -90,// -305
                        child: SvgPicture.asset(
                          Assets.personalityBar,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  height: 30,
                  width: 50,
                  child: SvgPicture.asset(Assets.traits[trait]!['positive']!),
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                "The bar lets you know what side are you on. Right being the extreme.",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "It adapts as you take multiple tests, and get to explore yourself better.",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            Button(
              text: 'Got it',
              onTap: () => Navigator.of(context).pushNamed('/personality/adjectives'),
            ),
          ],
        ),
      )),
    );
  }
}
