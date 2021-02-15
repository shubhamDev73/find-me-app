import 'package:carousel_slider/carousel_slider.dart';
import 'package:findme/UI/Widgets/addAdjListItems.dart';
import 'package:findme/UI/Widgets/greetings.dart';
import 'package:findme/UI/Widgets/menuButton.dart';
import 'package:findme/UI/Widgets/traits.dart';
import 'package:findme/configs/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:findme/API.dart';

FutureBuilder<Map<String, dynamic>> createPersonality(Function callback,
    Future<Map<String, dynamic>> futurePersonality, String trait) {
  return FutureBuilder<Map<String, dynamic>>(
    future: futurePersonality,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        Map<String, dynamic> traitData = snapshot.data[trait];
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Greeting(
              title: trait,
              desc: traitData['description'],
            ),
            TraitsElements(
                onClick:
                    (String traitString, Map<String, dynamic> personality) {
                  callback(traitString, personality);
                },
                personality: snapshot.data,
                selectedElement: trait),
          ],
        );
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      // By default, show a loading spinner.
      return CircularProgressIndicator();
    },
  );
}

class ProfileLandingTrait extends StatefulWidget {
  const ProfileLandingTrait({
    Key key,
  }) : super(key: key);
  @override
  _ProfileLandingTraitState createState() => _ProfileLandingTraitState();
}

class _ProfileLandingTraitState extends State<ProfileLandingTrait> {
  String trait = '';
  double value = 0.50;
  List adjectives = [];
  int _current = 0;

  Future<Map<String, dynamic>> futurePersonality;

  @override
  void initState() {
    super.initState();
    futurePersonality = GETResponse<Map<String, dynamic>>('me/personality/',
      callback: (Map<String, dynamic> personality) {
        setState(() {
          value = personality[trait]['value'];
          adjectives = personality[trait]['adjectives'];
        });
    });
  }

  Container buildAdjCarouselSlider() {
    return Container(
      constraints: BoxConstraints(
          minWidth: 340, minHeight: 206, maxWidth: 340, maxHeight: 206),
      decoration: BoxDecoration(
          color: const Color(0xFFE0F7FA),
          borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.fromLTRB(
        10.0,
        0.0,
        10.0,
        0.0,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            child: CarouselSlider(
              options: CarouselOptions(
                  // height: height,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  initialPage: 0,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: adjectives
                  .map((adjective) => Builder(
                        builder: (BuildContext context) {
                          return AdjListItem(
                            adj: adjective['name'],
                            des: "OHHHHHH BOYYYYAAAAA",
                            des2:
                                "this trait of ether shows lorem epsum about you this space will provide information about each facet of the personality in detail",
                            // des2: adjective['description']
                          );
                        },
                      ))
                  .toList(),
            ),
          ),
          Positioned(
            top: 125,
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
                    border: _current == index
                        ? null
                        : Border.all(color: Colors.black),
                    color: _current == index
                        ? Color(0xFF000000)
                        : Color(0xFFFFFFFF),
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              constraints: BoxConstraints(
                  minWidth: 340, minHeight: 45, maxWidth: 340, maxHeight: 45),
              decoration: BoxDecoration(
                  // color: const Color(0xFFE0F7FA),
                  color: const Color(0xFFE0F7FA),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: 31,
                      minWidth: 101,
                      maxWidth: 101,
                      maxHeight: 31),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
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
    setState(() {
      if (trait == '') trait = ModalRoute.of(context).settings.arguments;
    });
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
                    child: createPersonality(
                        (String traitString, Map<String, dynamic> personality) {
                      setState(() {
                        trait = traitString;
                        value = personality[trait]['value'];
                        adjectives = personality[trait]['adjectives'];
                      });
                    }, futurePersonality, trait),
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
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 10.0),
                        ),
                        // ignore: missing_required_param
                        child: Slider(
                          value: value,
                          min: -1.0,
                          max: 1.0,
                          inactiveColor: Color(0xFF8D8E98),
                          // onChanged: (double newValue) {
                          //   setState(() {
                          //     height = newValue.round();
                          //   });
                          // },
                        ),
                      ),
                      SvgPicture.asset(Assets.traits[trait]['positive']),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Text(
                        "Take a test",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
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
                child: Container(child: buildAdjCarouselSlider()),
              ),
            ),
            MenuButton(),
          ],
        ),
      ),
    );
  }
}
