import 'package:flutter/material.dart';

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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 50),
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
                    child: Text(
                      "Your psyche is divided into five elements",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 45),
                    child: TraitButton(trait: trait, value: personality[trait]!, selected: true, onTap: (){}),
                  ),
                  Container(
                    width: 270,
                    child: Text(
                      "These elements make up a crucial part of your self",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 40),
                    width: 270,
                    child: Text(
                      "each element has two ends and we lie somewhere in between",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
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
