import 'package:findme/UI/Widgets/greatings/greatings.dart';
import 'package:findme/UI/Widgets/traits.dart';
import 'package:findme/UI/Widgets/userInfo.dart';
import 'package:findme/data/models/intrests.dart';
import 'package:flutter/material.dart';

import '../../Widgets/activityButtons.dart';
import '../../../activityTwo.dart';
import '../../Widgets/menuButton.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    List<Intrest> intrest = [
      Intrest(title: "Drama", intensity: 0.8),
      Intrest(title: "Reading", intensity: 0.7),
      Intrest(title: "Swimming", intensity: 0.6),
      Intrest(title: "Music", intensity: 0.5),
      Intrest(title: "Coding", intensity: 0.4),
    ];
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
                    color: Color(0xffDFF7F9),
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
                      children: [
                        Greating(),
                        TraitsElements(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: UserInfo(),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActivityButton(
                        title: intrest[0].title,
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ActivityTwo(title: intrest[0].title),
                            ),
                          );
                        },
                        intensity: intrest[0].intensity,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ActivityButton(
                        title: intrest[1].title,
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ActivityTwo(title: intrest[1].title),
                            ),
                          );
                        },
                        intensity: intrest[1].intensity,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActivityButton(
                        title: intrest[2].title,
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ActivityTwo(title: intrest[2].title),
                            ),
                          );
                        },
                        intensity: intrest[2].intensity,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ActivityButton(
                        title: intrest[3].title,
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivityTwo(
                                title: intrest[3].title,
                              ),
                            ),
                          );
                        },
                        intensity: intrest[3].intensity,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ActivityButton(
                        title: intrest[4].title,
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivityTwo(
                                title: intrest[4].title,
                              ),
                            ),
                          );
                        },
                        intensity: intrest[4].intensity,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  menuButton(
                      key: "Menu button 2",
                      scaffoldKey: widget.scaffoldKey,
                      selected: true,
                      icon: Icons.ac_unit),
                  menuButton(
                      key: "Menu button 3",
                      scaffoldKey: widget.scaffoldKey,
                      selected: false,
                      icon: Icons.access_alarm),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
