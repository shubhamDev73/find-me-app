import 'package:flutter/material.dart';

import 'package:findme/globals.dart' as globals;
import 'package:findme/UI/Widgets/greetings.dart';
import 'package:findme/UI/Widgets/traits.dart';
import 'package:findme/UI/Widgets/userInfo.dart';
import 'package:findme/UI/Widgets/menuButton.dart';
import 'package:findme/UI/Widgets/interestButton.dart';
import 'package:findme/data/models/user.dart';
import 'package:findme/data/models/interests.dart';
import 'package:findme/API.dart';

FutureBuilder<User> createTraits(Future<User> futureUser) {
  return FutureBuilder<User>(
    future: futureUser,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return TraitsElements(
            onClick: (String trait, Map<String, dynamic> personality) {
              Navigator.pushNamed(context, "/profileLandingTrait",
                  arguments: trait);
            },
            personality: snapshot.data.personality);
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      // By default, show a loading spinner.
      return CircularProgressIndicator();
    },
  );
}

FutureBuilder<User> createInterest(Future<User> futureUser, int index) {
  return FutureBuilder<User>(
    future: futureUser,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        Interest interest = snapshot.data.interests[index];
        return InterestButton(
          name: interest.name,
          onClick: () {
            Navigator.pushNamed(context, "/profileInterestLanding",
                arguments: interest.id);
          },
          amount: interest.amount,
        );
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      // By default, show a loading spinner.
      return CircularProgressIndicator();
    },
  );
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
  Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    globals.token =
        'e06df4fbae56e7ed03aadb66c233368a4b93fef115728896a220b60ed5e81ede';
    futureUser = GETResponse<User>('me/', decoder: (result) => User.fromJson(result));
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
                        createTraits(futureUser),
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
                child: UserInfo(futureUser),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createInterest(futureUser, 0),
                      SizedBox(
                        width: 12,
                      ),
                      createInterest(futureUser, 1),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createInterest(futureUser, 2),
                      SizedBox(
                        width: 12,
                      ),
                      createInterest(futureUser, 3),
                      SizedBox(
                        width: 12,
                      ),
                      createInterest(futureUser, 4),
                    ],
                  )
                ],
              ),
            ),
            MenuButton(),
          ],
        ),
      ),
    );
  }
}
