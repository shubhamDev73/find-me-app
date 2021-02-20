import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:findme/widgets/interestButton.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/topBox.dart';

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
      backgroundColor: ThemeColors.lightColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: TopBox(
                title: "Interests",
                desc: "tap and tap",
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
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
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,
                    ),
                    children: interests.map<Widget>((Interest interest) => InterestButton(
                      name: interest.name,
                      onClick: (amount) {
                        interest.amount = amount;
                        findInterest(globals.interests, interest.id).amount = amount;

                        POST('me/interests/update/', jsonEncode([{"interest": interest.id, "amount": interest.amount}]), true);

                        Interest foundInterest = findInterest(globals.meUser.interests, interest.id);
                        if(foundInterest == null){
                          if(amount != 0) globals.meUser.interests.add(interest);
                        }else{
                          if(amount == 0) globals.meUser.interests.remove(foundInterest);
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
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
