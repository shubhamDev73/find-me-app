import 'dart:collection';
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

class AddInterests extends StatelessWidget {

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<User>(globals.meUser.get(), (User user) =>
      createFutureWidget<LinkedHashMap<int, Interest>>(globals.interests.get(), (LinkedHashMap<int, Interest> interests) => Scaffold(
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
                    controller: scrollController,
                    child: GridView(
                      controller: scrollController,
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

                          POST('me/interests/update/', jsonEncode([{"interest": interest.id, "amount": interest.amount}]));

                          globals.meUser.update((User user) {
                            if(user.interests.containsKey(interest.id)){
                              if(amount == 0) user.interests.remove(interest.id);
                              else user.interests[interest.id].amount = amount;
                            }else{
                              if(amount != 0) user.interests[interest.id] = interest;
                            }
                            return user;
                          });
                        },
                        amount: user.interests.containsKey(interest.id) ? user.interests[interest.id].amount : 0,
                        canChangeAmount: true,
                      )).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      )),
    );
  }
}
