import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:findme/widgets/interestButton.dart';
import 'package:findme/widgets/misc.dart';

import 'package:findme/models/interests.dart';
import 'package:findme/constant.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class AddInterests extends StatefulWidget {

  @override
  _AddInterestsState createState() => _AddInterestsState();
}

class _AddInterestsState extends State<AddInterests> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState () {
    super.initState();
    globals.getUser();
    globals.getInterests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: ThemeColors.lightColor,
              constraints: BoxConstraints(maxHeight: 67, minHeight: 67),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.more_vert),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      "Interests",
                      style: TextStyle(
                        fontFamily: 'QuickSand',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment(0.0, 0.0),
                  ),
                  Container(
                    child: Text(
                      "tap and tap",
                      style: TextStyle(
                        fontFamily: 'QuickSand',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    alignment: Alignment(0.0, 0.75),
                  ),
                ],
              ),
            ),
            Container(
              color: ThemeColors.lightColor,
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Container(
                constraints: BoxConstraints(minWidth: 245, maxWidth: 245),
                child: Scrollbar(
                  thickness: 0,
                  isAlwaysShown: true,
                  controller: _scrollController,
                  child: createFutureWidget<List<Interest>>(globals.futureInterests, (List<Interest> interests) => GridView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3.3,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 9,
                      crossAxisCount: 3,
                    ),
                    children: interests.map<Widget>((Interest interest) => InterestButton(
                      name: interest.name,
                      onClick: (amount) {
                        interest.amount = amount;
                        findInterest(globals.interests, interest.id).amount = amount;

                        POST('me/interests/update/', jsonEncode([{"interest": interest.id, "amount": interest.amount}]), true);

                        Interest foundInterest = findInterest(globals.user.interests, interest.id);
                        if(foundInterest == null){
                          if(amount != 0) globals.user.interests.add(interest);
                        }else{
                          if(amount == 0) globals.user.interests.remove(foundInterest);
                          else foundInterest.amount = amount;
                        }

                        globals.getUser();
                      },
                      amount: interest.amount,
                      canChangeAmount: true,
                    )).toList(),
                  )),
                ),
              ),
              constraints: BoxConstraints(maxHeight: 517, minWidth: 517),
            ),
          ],
        ),
      ),
    );
  }
}
