import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:findme/widgets/interestButton.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/topBox.dart';

import 'package:findme/models/user.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/constant.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

class AddInterests extends StatefulWidget {

  final ScrollController scrollController = ScrollController();

  @override
  _AddInterestsState createState() => _AddInterestsState();
}

class _AddInterestsState extends State<AddInterests> {

  Future<Map<int, Interest>> futureInterests;

  @override
  void initState () {
    super.initState();
    globals.getUser();
    futureInterests = globals.interests.get();
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
                  controller: widget.scrollController,
                  child: createFutureWidget<Map<int, Interest>>(futureInterests, (Map<int, Interest> interests) => GridView(
                    controller: widget.scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3.3,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,
                    ),
                    children: interests.values.map<Widget>((Interest interest) => InterestButton(
                      name: interest.name,
                      onClick: (amount) {
                        interest.amount = amount;
                        globals.interests.mappedSet(interest.id, interest);

                        POST('me/interests/update/', jsonEncode([{"interest": interest.id, "amount": interest.amount}]));

                        User user = globals.meUser.getValue();
                        if(user.interests.containsKey(interest.id)){
                          if(amount == 0) user.interests.remove(interest.id);
                          else user.interests[interest.id].amount = amount;
                        }else{
                          if(amount != 0) user.interests[interest.id] = interest;
                        }
                        globals.meUser.set(user);
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
