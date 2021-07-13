import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:findme/widgets/adjectiveListItems.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/traitBar.dart';
import 'package:findme/assets.dart';
import 'package:findme/models/user.dart';
import 'package:findme/constant.dart';
import 'package:findme/globals.dart' as globals;

final random = new Random();

class AdjectiveCarousel extends StatefulWidget {

  final List<dynamic> adjectives;
  const AdjectiveCarousel({this.adjectives});

  @override
  _AdjectiveCarouselState createState() => _AdjectiveCarouselState();
}

class _AdjectiveCarouselState extends State<AdjectiveCarousel> {

  int currentAdjIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 340,
      decoration: BoxDecoration(
        color: ThemeColors.boxColor,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            flex: 3,
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
              items: widget.adjectives.map((facetAdjectives) {
                Map<String, dynamic> adjective = facetAdjectives[random.nextInt(facetAdjectives.length)];
                return Builder(
                  builder: (BuildContext context) {
                    return AdjListItem(
                      name: adjective['name'],
                      description: adjective['description'],
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.adjectives.map((adjective) {
                int index = widget.adjectives.indexOf(adjective);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: currentAdjIndex == index ? null : Border.all(color: Colors.black),
                    color: currentAdjIndex == index ? Colors.black : Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class Personality extends StatefulWidget {

  final bool me;
  const Personality({this.me = true});

  @override
  _PersonalityState createState() => _PersonalityState();
}

class _PersonalityState extends State<Personality> {

  String trait;

  @override
  void initState() {
    super.initState();
    if(widget.me) globals.onUserChanged['personality'] = () => setState(() {});
  }

  @override
  void dispose() {
    if(widget.me) globals.onUserChanged.remove('personality');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (trait == null) trait = ModalRoute.of(context).settings.arguments;

    return createFutureWidget<User>(globals.getUser(me: widget.me), (User user) => Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 9,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    color: ThemeColors.boxColor,
                  ),
                  Container(
                    height: 234,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          height: 170,
                          color: ThemeColors.boxColor,
                          child: Column(
                            children: [
                              SizedBox(height: 24),
                              Container(
                                height: 50,
                                child: Text(
                                  trait,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                                    width: 50,
                                    child: SvgPicture.asset(Assets.traits[trait]['negative']),
                                  ),
                                  Container(
                                    width: 220,
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Divider(
                                          color: Colors.black,
                                          height: 20,
                                          thickness: 1,
                                        ),
                                        Positioned(
                                          left: ((user.personality[trait]['value'] + 1) / 2) * 220 - 4,
                                          child: Container(
                                            height: 20,
                                            width: 8,
                                            decoration: BoxDecoration(
                                              color: ThemeColors.boxColor,
                                              border: Border.all(),
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                                    width: 50,
                                    child: SvgPicture.asset(Assets.traits[trait]['positive']),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 25),
                child: Text(
                  user.personality[trait]['description'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                List<dynamic> urls = user.personality[trait]['url'];
                String url = urls[random.nextInt(urls.length)];
                if(await canLaunch(url)) await launch(url);
              },
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
            Expanded(
              flex: 1,
              child: Text(
                "Your attributes for this trait",
                style: TextStyle(fontSize: 18),
              ),
            ),
            AdjectiveCarousel(adjectives: user.personality[trait]['adjectives']),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            widget.me ?
            GestureDetector(
              onTap: () async {
                String url = 'https://tripetto.app/run/YK2S455EX3/?nick=${user.nick}';
                if(await canLaunch(url)) await launch(url);
              },
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
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ) :
            Container(),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  "Taking test helps us find better conversations for you",
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
    ));
  }
}
