import 'package:flutter/material.dart';

import 'package:findme/globals.dart' as globals;
import 'package:findme/UI/Widgets/greetings.dart';
import 'package:findme/UI/Widgets/traitBar.dart';
import 'package:findme/UI/Widgets/userInfo.dart';
import 'package:findme/UI/Widgets/misc.dart';
import 'package:findme/UI/Widgets/interestButton.dart';
import 'package:findme/data/models/user.dart';
import 'package:findme/data/models/interests.dart';
import 'package:findme/configs/assets.dart';

FutureBuilder<User> createInterest(BuildContext context, int index) {
  return createFutureWidget<User>(globals.futureUser, (User user) {
    Interest interest = user.interests[index];
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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    globals.token =
        'e06df4fbae56e7ed03aadb66c233368a4b93fef115728896a220b60ed5e81ede';
    globals.getUser();
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
              child: Column(
                children: [
                  Container(
                    color: Color(0xffE0F7FA),
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.more_vert),
                      ],
                    ),
                  ),
                  Container(
                    height: 180,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Greeting(
                          title: "Konichiwa",
                          desc: "Did you know the US armys traning bumbelbees to sniff out explosive?",
                        ),
                        createFutureWidget<User>(globals.futureUser, (User user) => TraitsElements(
                          onClick: (String trait) {
                            Navigator.of(context).pushNamed('/personality', arguments: trait);
                          },
                          personality: user.personality,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/mood');
                },
                child: createFutureWidget<User>(globals.futureUser, (User user) => UserInfo(user)),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createInterest(context, 0),
                      SizedBox(width: 12),
                      createInterest(context, 1),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createInterest(context, 2),
                      SizedBox(width: 12),
                      createInterest(context, 3),
                      SizedBox(width: 12),
                      createInterest(context, 4),
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
