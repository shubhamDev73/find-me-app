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

FutureBuilder<User> createInterest(futureUser, BuildContext context, int index) {
  return createFutureWidget<User>(futureUser, (User user) {
    if(index == 4){
      return InterestButton(
        name: Assets.plus,
        isSvg: true,
        selected: true,
        onClick: () {
          Navigator.of(context).pushNamed('/interests', arguments: user.interests[0].id);
        },
      );
    }else{
      Interest interest = user.interests[index];
      return InterestButton(
        name: interest.name,
        amount: interest.amount,
        onClick: () {
          Navigator.of(context).pushNamed('/interests', arguments: interest.id);
        },
      );
    }
  });
}

class Profile extends StatefulWidget {

  final bool me;
  const Profile({this.me = true});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    globals.token =
        'e06df4fbae56e7ed03aadb66c233368a4b93fef115728896a220b60ed5e81ede';
    futureUser = globals.getUser(me: widget.me);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                widget: createFutureWidget<User>(futureUser, (User user) => TraitsElements(
                  onClick: (String trait) {
                    Navigator.of(context).pushNamed('/personality', arguments: trait);
                  },
                  personality: user.personality,
                )),
              ),
            ),
            Expanded(
              flex: 8,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/mood');
                },
                child: createFutureWidget<User>(futureUser, (User user) => UserInfo(user)),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createInterest(futureUser, context, 0),
                      SizedBox(width: 12),
                      createInterest(futureUser, context, 1),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createInterest(futureUser, context, 2),
                      SizedBox(width: 12),
                      createInterest(futureUser, context, 3),
                      SizedBox(width: 12),
                      createInterest(futureUser, context, 4),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
