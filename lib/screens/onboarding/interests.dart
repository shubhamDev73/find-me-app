import 'package:flutter/material.dart';

import 'package:findme/widgets/interestButton.dart';
import 'package:findme/widgets/topBox.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/constant.dart';

class Interests extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.lightColor,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: TopBox(
              height: 200,
              title: "Interests",
              description: "Interests tell us what you like, and how much you like it",
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Tap on an interest multiple times to indicate how strong your interest is",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: InterestInfo(),
          ),
        ],
      ),
    );
  }
}

class InterestInfo extends StatefulWidget {

  final List<String> infoTexts = ['not interested', 'mildly interested', 'somewhat interested', 'highly interested'];

  @override
  _InterestInfoState createState() => _InterestInfoState();
}

class _InterestInfoState extends State<InterestInfo> {

  int amount = 0;
  bool canProceed = false;

  @override
  Widget build (BuildContext context) {
    return Column(
      children: [
        InterestButton(
          onClick: (amount) => setState(() {this.amount = amount; if(amount == 3) canProceed = true;}),
          name: 'Interest',
          canChangeAmount: true,
        ),
        SizedBox(height: 30),
        Text(
          widget.infoTexts[amount],
        ),
        SizedBox(height: 30),
        canProceed ? Button(
          text: "Proceed",
          onTap: () => Navigator.of(context).pushNamed('/interests/add'),
        ) : Container(),
      ],
    );
  }
}
