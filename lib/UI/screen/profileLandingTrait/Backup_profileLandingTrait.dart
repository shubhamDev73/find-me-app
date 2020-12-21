import 'dart:convert';

import 'package:findme/UI/Widgets/greatings/greatings.dart';
import 'package:findme/UI/Widgets/menuButton.dart';
import 'package:findme/UI/Widgets/traits.dart';
import 'package:findme/configs/assets.dart';
import 'package:findme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:findme/API.dart';

Future<Map<String, dynamic>> fetchPersonality(
    Function callback, String trait) async {
  final response = await GET('me/personality');

  if (response.statusCode == 200) {
    Map<String, dynamic> personality = jsonDecode(response.body);
    callback(personality[trait]['value'], personality[trait]['adjectives']);
    return personality;
  } else {
    throw Exception('Failed to load personality: ${response.statusCode}');
  }
}

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
            Greating(
              title: trait,
              desc: traitData['description'],
            ),
            TraitsElements(personality: snapshot.data, selectedElement: trait),
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
  double value = 0.50;
  List adjectives = [];

  Future<Map<String, dynamic>> futurePersonality;

  @override
  void initState() {
    super.initState();
    futurePersonality =
        fetchPersonality((double traitValue, List traitAdjectives) {
      setState(() {
        value = traitValue;
        adjectives = traitAdjectives;
      });
    }, "Air");
  }

  @override
  Widget build(BuildContext context) {
    final trait = ModalRoute.of(context).settings.arguments;
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
                        (double traitValue, List traitAdjectives) {
                      setState(() {
                        value = traitValue;
                        adjectives = traitAdjectives;
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
                      SvgPicture.asset(Assets.traits[trait],
                          color: MyColors.negativeTraitColor),
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
                      SvgPicture.asset(
                        Assets.traits[trait],
                        color: MyColors.primaryColor,
                      ),
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
              child: ListView.builder(
                itemCount: adjectives.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Color(0xffE0F7FA),
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      adjectives[index]['name'],
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
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
                  "Explore",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            MenuButton(),
          ],
        ),
      ),
    );
  }
}

// CarouselSlider(
//             carouselController: buttonCarouselController,
//             items: intrest.questions
//                 .map((question) => Builder(
//                       builder: (BuildContext context) {
//                         return Container(
//                           margin: EdgeInsets.symmetric(horizontal: 35),
//                           child: Center(
//                             child: Text(
//                               question['question'],
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ))
//                 .toList(),
//             options: CarouselOptions(
//                 initialPage: 0,
//                 // autoPlay: true,
//                 enlargeCenterPage: true,
//                 aspectRatio: 2.0,
//                 onPageChanged: (index, reason) {
//                   onPageChange(intrest.questions[index]['answer']);
//                 }),
//           )
