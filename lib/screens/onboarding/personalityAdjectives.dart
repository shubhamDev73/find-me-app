import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:findme/widgets/adjectiveListItems.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/traitBar.dart';
import 'package:findme/widgets/topBox.dart';
import 'package:findme/assets.dart';
import 'package:findme/models/user.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

final random = new Random();
final int numberOfAdjectives = 5;

class PersonalityAdjectives extends StatefulWidget {

  @override
  _PersonalityAdjectivesState createState() => _PersonalityAdjectivesState();
}

class _PersonalityAdjectivesState extends State<PersonalityAdjectives> {

  String trait = 'Water';
  Map<String, List<dynamic>> adjectives = {};

  void createRandomAdjectives(User user) {
    adjectives.clear();

    for(String trait in user.personality.keys) {
      List<dynamic> randomAdjectives = List.empty(growable: true);
      List<dynamic> allAdjectives = List.empty(growable: true);

      for (List<dynamic> facetAdjectives in user.personality[trait]['adjectives']) {
        allAdjectives.add(facetAdjectives[random.nextInt(facetAdjectives.length)]);
      }

      int length = allAdjectives.length;
      if (length <= numberOfAdjectives)
        randomAdjectives = allAdjectives;
      else {
        for (int i = 0; i < numberOfAdjectives; i++) {
          dynamic adjective = allAdjectives[random.nextInt(length)];
          while (randomAdjectives.contains(adjective)) {
            adjective = allAdjectives[random.nextInt(length)];
          }
          randomAdjectives.add(adjective);
        }
      }

      adjectives[trait] = randomAdjectives;
    }
  }

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<User>(globals.meUser.get(), (User user) =>
      createFutureWidget<Map<String, Map<String, dynamic>>>(globals.personality.get(), (Map<String, Map<String, dynamic>> personality) {
        if (adjectives.isEmpty) createRandomAdjectives(user);

        return Scaffold(
          body: Column(
            children: [
              TopBox(
                title: trait,
                secondaryWidget: Row(
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
                widget: TraitsElements(
                  onClick: (String traitString) => setState(() {trait = traitString;}),
                  personality: user.personality,
                  selectedElement: trait,
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
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
              ),
              Button(
                text: "Explore",
                onTap: () async {
                  List<dynamic> urls = user.personality[trait]['url'];
                  String url = urls[random.nextInt(urls.length)];
                  if(await canLaunch(url)) await launch(url);
                },
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "Your attributes for this trait",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                height: 180,
                width: 340,
                decoration: BoxDecoration(
                  color: ThemeColors.boxColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Carousel(
                  items: adjectives[trait]!,
                  widget: (adjective) => AdjListItem(
                    name: adjective['name'],
                    description: adjective['description'],
                  ),
                  gap: 140,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Button(
                text: "Got it",
                onTap: () {
                  globals.onboardingCallbacks['personality']?.call();
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                },
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
