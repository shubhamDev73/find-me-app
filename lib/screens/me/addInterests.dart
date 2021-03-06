import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:findme/widgets/interestButton.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/topBox.dart';
import 'package:findme/models/user.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;
import 'package:findme/events.dart' as events;

class AddInterests extends StatefulWidget {

  @override
  _AddInterestsState createState() => _AddInterestsState();
}

class _AddInterestsState extends State<AddInterests> {

  @override
  void initState() {
    super.initState();
    globals.onInterestsChanged = () => setState(() {});
    globals.onUserChanged['addInterests'] = () => setState(() {});
  }

  @override
  void dispose() {
    globals.onInterestsChanged = null;
    globals.onUserChanged.remove('addInterests');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<User>(globals.meUser.get(), (User user) =>
      createFutureWidget<LinkedHashMap<int, Interest>>(globals.interests.get(), (LinkedHashMap<int, Interest> interests) => Scaffold(
        backgroundColor: ThemeColors.lightColor,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: TopBox(
                height: 100,
                title: "Interests",
                description: "tap and tap",
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
                    children: <Widget>[Container(), Container(), Container()] + interests.values.toList().reversed.map<Widget>((Interest interest) => InterestButton(
                      name: interest.name,
                      onClick: (amount) {
                        interest.amount = amount;

                        globals.addPostCall(
                          'me/interests/update/',
                          {"interest": interest.id, "amount": interest.amount, "timestamp": DateTime.now().toUtc().toString()},
                          overwrite: (body) => body['interest'] == interest.id,
                          collect: true,
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
                        events.sendEvent('addInterest', {"interest": interest.id, "amount": amount});
                      },
                      amount: user.interests.containsKey(interest.id) ? user.interests[interest.id]!.amount! : 0,
                      canChangeAmount: interest.id != 0,
                    )).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      )),
    );
  }
}
