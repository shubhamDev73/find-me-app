import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProfileIntrestLanding extends StatefulWidget {
  @override
  _ProfileIntrestLandingState createState() => _ProfileIntrestLandingState();
}

class _ProfileIntrestLandingState extends State<ProfileIntrestLanding> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    CarouselController buttonCarouselController = CarouselController();
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(initialPage: returnKey(args)),
                    carouselController: buttonCarouselController,
                    items: ["Drama", "Music", "Swimming", "Reading"].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            margin: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  returnText(i),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Positioned(
                    top: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () => buttonCarouselController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.decelerate),
                            child: Container(
                              height: 40,
                              width: 40,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6888,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () => buttonCarouselController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.decelerate),
                            child: Container(
                              height: 40,
                              width: 40,
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
            ],
          ),
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
      return "an art of sound in time that expresses ideas and emotions in significant forms through the elements of rhythm, melody, harmony, and color.";
    } else if (key == "Swimming") {
      return "the skill or technique of a person who swims.";
    } else if (key == "Reading") {
      return "the action or practice of a person who reads.";
    }
    return "bye";
  }
}
