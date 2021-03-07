import 'package:flutter/material.dart';

import 'package:findme/globals.dart' as globals;
import 'package:findme/widgets/topBox.dart';
import 'package:findme/widgets/traitBar.dart';
import 'package:findme/widgets/userInfo.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/interestButton.dart';
import 'package:findme/models/user.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/assets.dart';

Widget createInterest(User user, BuildContext context, int index) {
  List<Interest> interests = user.interests.values.toList();
  if(index == 4){
    return InterestButton(
      name: Assets.plus,
      isSvg: true,
      selected: true,
      onClick: () {
        Navigator.of(context).pushNamed('/interests', arguments: interests[0].id);
      },
    );
  }else{
    Interest interest = interests[index];
    return InterestButton(
      name: interest.name,
      amount: interest.amount,
      onClick: () {
        Navigator.of(context).pushNamed('/interests', arguments: interest.id);
      },
    );
  }
}

class Profile extends StatelessWidget {

  final bool me;
  const Profile({this.me = true});

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<User>(globals.getUser(me: me), (User user) => Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: TopBox(
                title: "Konichiwa",
                desc: "Did you know the US armys traning bumbelbees to sniff out explosive?",
                widget: TraitsElements(
                  onClick: (String trait) {
                    Navigator.of(context).pushNamed('/personality', arguments: trait);
                  },
                  personality: user.personality,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/mood');
                },
                child: UserInfo(user),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createInterest(user, context, 0),
                      SizedBox(width: 12),
                      createInterest(user, context, 1),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createInterest(user, context, 2),
                      SizedBox(width: 12),
                      createInterest(user, context, 3),
                      SizedBox(width: 12),
                      createInterest(user, context, 4),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
