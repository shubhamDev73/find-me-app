import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:findme/widgets/topBox.dart';
import 'package:findme/widgets/traitBar.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/user.dart';
import 'package:findme/globals.dart' as globals;

final random = new Random();

class PersonalityElements extends StatefulWidget {

  final Map<String, double> personality = {"Water": 0.6, "Air": 0.5, "Space": -0.5, "Earth": -0.4, "Fire": 0.3};
  final Map<String, String> descriptions = {"Water": "extrovert", "Air": "open", "Space": "conscientious", "Earth": "agreeable", "Fire": "neurotic"};

  @override
  _PersonalityElementsState createState() => _PersonalityElementsState();
}

class _PersonalityElementsState extends State<PersonalityElements> {

  String trait = 'Water';
  bool testTaken = false;

  @override
  Widget build(BuildContext context) {
    globals.context = context;
    return createFutureWidget<User>(globals.meUser.get(), (User user) =>
      createFutureWidget<Map<String, Map<String, dynamic>>>(globals.personality.get(), (Map<String, Map<String, dynamic>> personality) => Scaffold(
        body: Column(
          children: [
            TopBox(
              description: "Each element represents two extremes of the same psyche. Tap on an element to know more.",
              height: 190,
              widget: TraitsElements(
                onClick: (traitString) => setState(() {trait = traitString;}),
                personality: widget.personality,
                selectedElement: trait,
              ),
            ),
            SizedBox(height: 50),
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
            SizedBox(height: 20),
            Container(
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: 24, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(text: '$trait describes how '),
                      TextSpan(text: '${widget.descriptions[trait]}', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' we are'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              child: Center(
                child: Text(
                  "To find out your personality elements",
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 24),
                ),
              ),
            ),
            SizedBox(height: 30),
            Button(
              text: "Take a Test",
              onTap: () async {
                List<dynamic> allUrls = personality['questionnaire']!['initial'];
                String url = '${allUrls[random.nextInt(allUrls.length)]}?nick=${user.nick}';
                if(await canLaunch(url)) await launch(url);
                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => setState(() {
                  testTaken = true;
                }));
              },
            ),
            SizedBox(height: 30),
            testTaken ? Button(
              text: "Proceed",
              onTap: () async {
                globals.meUser.clear();
                Navigator.of(context).pushNamed('/personality/bar');
              },
            ) : Container(),
          ],
        ),
      )),
    );
  }
}
