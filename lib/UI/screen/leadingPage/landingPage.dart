import 'package:findme/UI/Widgets/greatings/greatings.dart';
import 'package:findme/UI/Widgets/traits.dart';
import 'package:findme/UI/Widgets/userInfo.dart';
import 'package:flutter/material.dart';

import '../../../activityButtons.dart';
import '../../../activityTwo.dart';
import '../../../menuButton.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({
    Key key,
    @required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    List intrest = ["Drama", "Reading", "Swimming", "Music", "Coding"];
    return SafeArea(
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 0,
                            child: Container(
                              color: Color(0xffDFF7F9),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.more_vert),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      child: Stack(
                        children: [
                          Greating(),
                          TraitsElements(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    UserInfo(),
                    SizedBox(
                      height: 80,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ActivityButton(
                              title: intrest[0],
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ActivityTwo(title: intrest[0]),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            ActivityButton(
                              title: intrest[1],
                              function: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ActivityTwo(title: intrest[1])));
                              },
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
                              title: intrest[2],
                              function: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ActivityTwo(title: intrest[2])));
                              },
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            ActivityButton(
                              title: intrest[3],
                              function: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ActivityTwo(
                                              title: intrest[3],
                                            )));
                              },
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            ActivityButton(
                              title: intrest[4],
                              function: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ActivityTwo(
                                              title: intrest[4],
                                            )));
                              },
                            ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(50),
                            //     boxShadow: [
                            //       BoxShadow(
                            //         offset: Offset(0, 2),
                            //         blurRadius: 8,
                            //         color: Colors.grey.shade400,
                            //         spreadRadius: 0,
                            //       ),
                            //     ],
                            //     color: Colors.white,
                            //   ),
                            //   height: 35,
                            //   width: 95,
                            //   child: Icon(
                            //     Icons.add,
                            //     color: Color(0xff00ADC2),
                            //   ),
                            // )
                          ],
                        )
                      ],
                    ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    //   margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(12),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         offset: Offset(0, 5),
                    //         blurRadius: 10,
                    //         color: Colors.grey.shade400,
                    //         spreadRadius: 0,
                    //       ),
                    //     ],
                    //     color: Color(0xffDFF7F9),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         "Some insight about the interest music like theri favorite tracks, or songs they sleep to",
                    //         textAlign: TextAlign.center,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(12),
                    //               border: Border.all(color: Colors.black),
                    //               color: Colors.white,
                    //             ),
                    //             margin: EdgeInsets.all(8),
                    //             height: 8,
                    //             width: 8,
                    //           ),
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(12),
                    //               border: Border.all(color: Colors.black),
                    //               color: Colors.white,
                    //             ),
                    //             margin: EdgeInsets.all(8),
                    //             height: 8,
                    //             width: 8,
                    //           ),
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(12),
                    //               color: Colors.black,
                    //             ),
                    //             margin: EdgeInsets.all(8),
                    //             height: 6,
                    //             width: 6,
                    //           ),
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(12),
                    //               border: Border.all(color: Colors.black),
                    //               color: Colors.white,
                    //             ),
                    //             margin: EdgeInsets.all(8),
                    //             height: 8,
                    //             width: 8,
                    //           ),
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(12),
                    //               border: Border.all(color: Colors.black),
                    //               color: Colors.white,
                    //             ),
                    //             margin: EdgeInsets.all(8),
                    //             height: 8,
                    //             width: 8,
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 42,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              menuButton(
                  key: "Menu button 2",
                  scaffoldKey: _scaffoldKey,
                  selected: true,
                  icon: Icons.ac_unit),
              menuButton(
                  key: "Menu button 3",
                  scaffoldKey: _scaffoldKey,
                  selected: false,
                  icon: Icons.access_alarm),
            ],
          ),
        ],
      ),
    );
  }
}
