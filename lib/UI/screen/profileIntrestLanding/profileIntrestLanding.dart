import 'package:carousel_slider/carousel_slider.dart';
import 'package:findme/UI/Widgets/activityButtons.dart';
import 'package:findme/UI/Widgets/menuButton.dart';
import 'package:findme/data/models/intrests.dart';
import 'package:flutter/material.dart';

class ProfileIntrestLanding extends StatefulWidget {
  @override
  _ProfileIntrestLandingState createState() => _ProfileIntrestLandingState();
}

class _ProfileIntrestLandingState extends State<ProfileIntrestLanding> {
  @override
  Widget build(BuildContext context) {
    List<Intrest> intrest = [
      Intrest(title: "Drama", intensity: 0.8),
      Intrest(title: "Reading", intensity: 0.7),
      Intrest(title: "Swimming", intensity: 0.6),
      Intrest(title: "Music", intensity: 0.5),
      Intrest(title: "Coding", intensity: 0.4),
    ];
    final args = ModalRoute.of(context).settings.arguments;
    CarouselController buttonCarouselController = CarouselController();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.more_vert),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(initialPage: returnKey(args)),
                    carouselController: buttonCarouselController,
                    items: ["Drama", "Music", "Swimming", "Reading"].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 35),
                            child: Center(
                              child: Text(
                                returnText(i),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Positioned(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: InkWell(
                            onTap: () => buttonCarouselController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.decelerate),
                            child: Container(
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: InkWell(
                            onTap: () => buttonCarouselController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.decelerate),
                            child: Container(
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                    child: Text(
                      "comfortably numb ; pink floyd",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 1,
                    width: 150,
                    color: Colors.black,
                  )
                ],
              ),
            ),

            // 24 maths 11:45
            // 26 e sci 8:30
            // 29 E AND V 8:30
            // 31 ENG 11:45 , PSP 8:30

            Expanded(
              flex: 6,
              child: Container(
                color: Color(0xffE0F7FA),
                child: Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ActivityButton(
                          title: intrest[0].title,
                          function: () {
                            Navigator.pushNamed(
                                context, "/profileIntrestLanding",
                                arguments: intrest[0].title);
                          },
                          intensity: intrest[0].intensity,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ActivityButton(
                          title: intrest[1].title,
                          function: () {
                            Navigator.pushNamed(
                                context, "/profileIntrestLanding",
                                arguments: intrest[0].title);
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
                            Navigator.pushNamed(
                                context, "/profileIntrestLanding",
                                arguments: intrest[0].title);
                          },
                          intensity: intrest[2].intensity,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ActivityButton(
                          title: intrest[3].title,
                          function: () {
                            Navigator.pushNamed(
                                context, "/profileIntrestLanding",
                                arguments: intrest[0].title);
                          },
                          intensity: intrest[3].intensity,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ActivityButton(
                          title: intrest[4].title,
                          function: () {
                            Navigator.pushNamed(
                                context, "/profileIntrestLanding",
                                arguments: intrest[0].title);
                          },
                          intensity: intrest[4].intensity,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ActivityButton(
                          title: intrest[0].title,
                          function: () {
                            Navigator.pushNamed(
                                context, "/profileIntrestLanding",
                                arguments: intrest[0].title);
                          },
                          intensity: intrest[0].intensity,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ActivityButton(
                          title: intrest[1].title,
                          function: () {
                            Navigator.pushNamed(
                                context, "/profileIntrestLanding",
                                arguments: intrest[0].title);
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
                            Navigator.pushNamed(
                                context, "/profileIntrestLanding",
                                arguments: intrest[0].title);
                          },
                          intensity: intrest[2].intensity,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ActivityButton(
                          title: intrest[3].title,
                          function: () {
                            Navigator.pushNamed(
                                context, "/profileIntrestLanding",
                                arguments: intrest[0].title);
                          },
                          intensity: intrest[3].intensity,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ActivityButton(
                          title: intrest[4].title,
                          function: () {
                            Navigator.pushNamed(
                                context, "/profileIntrestLanding",
                                arguments: intrest[0].title);
                          },
                          intensity: intrest[4].intensity,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ActivityButton(
                          title: intrest[0].title,
                          function: () {
                            Navigator.pushNamed(
                                context, "/profileIntrestLanding",
                                arguments: intrest[0].title);
                          },
                          intensity: intrest[0].intensity,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ActivityButton(
                          title: intrest[1].title,
                          function: () {
                            Navigator.pushNamed(
                                context, "/profileIntrestLanding",
                                arguments: intrest[0].title);
                          },
                          intensity: intrest[1].intensity,
                        ),
                      ],
                    ),
                  ],
                ),
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
                  "+ Interests",
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

  int returnKey(key) {
    if (key == "Drama") {
      return 0;
    } else if (key == "Music") {
      return 1;
    } else if (key == "Swimming") {
      return 2;
    } else if (key == "Reading") {
      return 3;
    }
    return 0;
  }

  String returnText(key) {
    if (key == "Drama") {
      return "a play for the theatre, radio or television";
    } else if (key == "Music") {
      return "What song helps you keep the demons at bay, thoughts in peace and sleep at night?";
    } else if (key == "Swimming") {
      return "the skill or technique of a person who swims.";
    } else if (key == "Reading") {
      return "the action or practice of a person who reads.";
    }
    return "bye";
  }
}
