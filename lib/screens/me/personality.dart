import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:findme/widgets/adjectiveListItems.dart';
import 'package:findme/widgets/topBox.dart';
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
      height: 206,
      width: 340,
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Column(
        children: [
          Expanded(
            flex: 2,
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
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: adjectives.map((adjective) {
                int index = adjectives.indexOf(adjective);
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
              flex: 9,
              child: createFutureWidget<User>(futureUser, (User user) => TopBox(
                title: trait,
                desc: user.personality[trait]['description'],
                widget: TraitsElements(
                  onClick: (String traitString) {
                    setState(() {
                      trait = traitString;
                    });
                  },
                  personality: user.personality,
                  selectedElement: trait,
                ),
              )),
            ),
            Expanded(
              flex: 4,
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: SvgPicture.asset(Assets.traits[trait]['negative']),
                      ),
                      Container(
                        width: 250,
                        child: SliderTheme(
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
                      ),
                      Container(
                        child: SvgPicture.asset(Assets.traits[trait]['positive']),
                      ),
                    ],
                  ),
            ),
            widget.me ?
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 42,
                width: 125,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Center(
                  child: Text(
                    "Take a Test",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ) :
            Container(),
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "Your attributes for this trait",
                style: TextStyle(fontSize: 17),
              ),
            ),
            createFutureWidget<User>(futureUser, (User user) => buildAdjCarouselSlider(user.personality[trait]['adjectives'])),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 37,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Center(
                  child: Text(
                    "Explore",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
