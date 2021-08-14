import 'package:flutter/material.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/traitBar.dart';
import 'package:findme/constant.dart';

class Personality extends StatelessWidget {

  final Map<String, double> personality = {"Water": 0.6, "Air": 0.5, "Space": -0.5, "Earth": -0.4, "Fire": 0.3};
  final String trait = 'Water';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 510,
                color: ThemeColors.boxColor,
              ),
              Column(
                children: [
                  Button(
                    type: 'back',
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Personality",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      "Your psyche is divided into five elements",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    child: TraitButton(trait: trait, value: personality[trait]!, selected: true, onTap: (){}),
                  ),
                  SizedBox(height: 40),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "These elements make up a crucial part of your self",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "each element has two ends and we lie somewhere in between",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  TraitsElements(
                    onClick: (traitString) => Navigator.of(context).pushNamed('/personality/elements'),
                    personality: personality,
                    selectedElement: trait,
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Tap on an element to begin",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
