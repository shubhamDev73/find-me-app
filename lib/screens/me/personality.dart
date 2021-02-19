import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:findme/widgets/adjectiveListItems.dart';
import 'package:findme/widgets/greetings.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/traitBar.dart';
import 'package:findme/assets.dart';
import 'package:findme/models/user.dart';
import 'package:findme/globals.dart' as globals;

class Personality extends StatefulWidget {

  final bool me;
  const Personality({this.me = true});

  @override
  _PersonalityState createState() => _PersonalityState();
}

class _PersonalityState extends State<Personality> {

  Future<User> futureUser;
  String trait;
  int currentAdjIndex = 0;

  @override
  void initState() {
    super.initState();
    futureUser = globals.getUser(me: widget.me);
  }

  Container buildAdjCarouselSlider(List adjectives) {
    return Container(
      constraints: BoxConstraints(minWidth: 340, minHeight: 206, maxWidth: 340, maxHeight: 206),
      decoration: BoxDecoration(
          color: const Color(0xFFE0F7FA),
          borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            child: CarouselSlider(
              options: CarouselOptions(
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  initialPage: 0,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentAdjIndex = index;
                    });
                  }),
              items: adjectives.map((adjective) => Builder(
                builder: (BuildContext context) {
                  return AdjListItem(
                    name: adjective['name'],
                    description: adjective['description'],
                  );
                },
              )).toList(),
            ),
          ),
          Positioned(
            top: 155,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: adjectives.map((url) {
                int index = adjectives.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: currentAdjIndex == index ? null : Border.all(color: Colors.black),
                    color: currentAdjIndex == index ? Color(0xFF000000) : Color(0xFFFFFFFF),
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 5,
            child: Container(
              constraints: BoxConstraints(minWidth: 340, minHeight: 45, maxWidth: 340, maxHeight: 45),
              decoration: BoxDecoration(color: const Color(0xFFE0F7FA), borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(minHeight: 31, minWidth: 101, maxWidth: 101, maxHeight: 31),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12),),
                  child: Center(
                    child: Text(
                      "Explore",
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (trait == null) trait = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Column(
                children: <Widget>[
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
                    child: createFutureWidget<User>(futureUser, (User user) => Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Greeting(
                          title: trait,
                          desc: user.personality[trait]['description'],
                        ),
                        TraitsElements(
                          onClick: (String traitString) {
                            setState(() {
                              trait = traitString;
                            });
                          },
                          personality: user.personality,
                          selectedElement: trait,
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.traits[trait]['negative']),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.black,
                          inactiveTrackColor: Colors.black,
                          trackHeight: 1.0,
                          thumbColor: Colors.white,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                        ),
                        child: createFutureWidget<User>(futureUser, (User user) => Slider(
                          value: user.personality[trait]['value'],
                          min: -1.0,
                          max: 1.0,
                          inactiveColor: Color(0xFF8D8E98),
                        )),
                      ),
                      SvgPicture.asset(Assets.traits[trait]['positive']),
                    ],
                  ),
                  widget.me ?
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Text(
                        "Take a test",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ) :
                  Container(),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Your attributes for this trait"),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: SizedBox(
                child: createFutureWidget<User>(futureUser, (User user) => buildAdjCarouselSlider(user.personality[trait]['adjectives'])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
