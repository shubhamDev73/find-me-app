import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:findme/widgets/interestButton.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/topBox.dart';
import 'package:findme/models/user.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

int _requiredInterests = 4;

class AddInterests extends StatefulWidget {

  @override
  _AddInterestsState createState() => _AddInterestsState();
}

class _AddInterestsState extends State<AddInterests> {

  bool canProceed = false;
  Set<Interest> selectedInterests = {};

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<User>(globals.meUser.get(), (User user) {
      selectedInterests.addAll(user.interests.values);
      if(selectedInterests.length >= _requiredInterests) canProceed = true;

      return createFutureWidget<LinkedHashMap<int, Interest>>(globals.interests.get(), (LinkedHashMap<int, Interest> interests) => Scaffold(
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Tap on an interest multiple times to indicate how strong your interest is",
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ThemeScrollbar(
                  child: GridView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3.3,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,
                    ),
                    children: interests.values.toList().map((Interest interest) => InterestButton(
                      name: interest.name,
                      onClick: (amount) {
                        interest.amount = amount;

                        if(amount == 0) selectedInterests.remove(interest);
                        else selectedInterests.add(interest);

                        if(selectedInterests.length >= _requiredInterests){
                          if(!canProceed) setState(() {
                            canProceed = true;
                          });
                        }else{
                          if(canProceed) setState(() {
                            canProceed = false;
                          });
                        }

                        globals.addPostCall(
                          'me/interests/update/',
                          {"interest": interest.id, "amount": interest.amount},
                          overwrite: (body) => body['interest'] == interest.id,
                        );

                        globals.meUser.update((User user) {
                          if(user.interests.containsKey(interest.id)){
                            if(amount == 0) user.interests.remove(interest.id);
                            else user.interests[interest.id]!.amount = amount;
                          }else{
                            if(amount != 0) user.interests[interest.id] = interest;
                          }
                          List<Interest> newInterests = user.interests.values.toList();
                          if(amount != 0){
                            newInterests.remove(interest);
                            newInterests.insert(0, interest);
                          }
                          user.interests = LinkedHashMap.fromIterable(newInterests, key: (interest) => interest.id, value: (interest) => interest);
                          return user;
                        });
                      },
                      amount: user.interests.containsKey(interest.id) ? user.interests[interest.id]!.amount! : 0,
                      canChangeAmount: true,
                    )).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            canProceed ? Button(
              text: "Proceed",
              onTap: () => Navigator.of(context).pushNamed('/interests/question', arguments: user.interests.values.toList()[0].id),
            ) : Container(),
            SizedBox(height: 20),
          ],
        ),
      ));
    });
  }
}
