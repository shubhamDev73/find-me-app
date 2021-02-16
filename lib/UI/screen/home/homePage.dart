import 'package:flutter/material.dart';

import 'package:findme/globals.dart' as globals;
import 'package:findme/UI/Widgets/greetings.dart';
import 'package:findme/UI/Widgets/traits.dart';
import 'package:findme/UI/Widgets/userInfo.dart';
import 'package:findme/UI/Widgets/misc.dart';
import 'package:findme/UI/Widgets/interestButton.dart';
import 'package:findme/data/models/user.dart';
import 'package:findme/data/models/interests.dart';

FutureBuilder<User> createInterest(BuildContext context, int index) {
  return createFutureWidget<User>(globals.futureUser, (User user) {
    Interest interest = user.interests[index];
    if(index == 4){
      return InterestButton(
        name: '+',
        onClick: () {
          Navigator.pushNamed(context, "/profileInterestLanding",
              arguments: user.interests[0].id);
        },
        selected: true,
      );
    }else{
      return InterestButton(
        name: interest.name,
        onClick: () {
          Navigator.pushNamed(context, "/profileInterestLanding",
              arguments: interest.id);
        },
        amount: interest.amount,
      );
    }
  });
}

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeScreen({
    Key key,
    @required this.scaffoldKey,
  }) : super(key: key);

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
      key: widget.scaffoldKey,
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
                          desc:
                              "Did you know the US armys traning bumbelbees to sniff out explosive?",
                        ),
                        createFutureWidget<User>(globals.futureUser, (User user) => TraitsElements(
                            onClick: (String trait) {
                              Navigator.pushNamed(context, "/profileLandingTrait",
                                  arguments: trait);
                            },
                            personality: user.personality)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/moodSet');
              },
              child: Expanded(
                flex: 7,
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
                      SizedBox(
                        width: 12,
                      ),
                      createInterest(context, 1),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createInterest(context, 2),
                      SizedBox(
                        width: 12,
                      ),
                      createInterest(context, 3),
                      SizedBox(
                        width: 12,
                      ),
                      createInterest(context, 4),
                    ],
                  )
                ],
              ),
            ),
            MenuButton('me'),
          ],
        ),
      ),
    );
  }
}
