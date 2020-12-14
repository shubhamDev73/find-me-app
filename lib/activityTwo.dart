import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ActivityTwo extends StatelessWidget {
  final String title;

  const ActivityTwo({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(initialPage: returnKey(title)),
                    carouselController: buttonCarouselController,
                    items: ["Drama", "Music", "Swimming", "Reading"].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            margin: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 5),
                                  blurRadius: 10,
                                  color: Colors.grey.shade400,
                                  spreadRadius: 0,
                                ),
                              ],
                              color: Color(0xffDFF7F9),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  returnText(i),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border:
                                              Border.all(color: Colors.black),
                                          color: Colors.white,
                                        ),
                                        margin: EdgeInsets.all(8),
                                        height: 8,
                                        width: 8,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border:
                                              Border.all(color: Colors.black),
                                          color: Colors.white,
                                        ),
                                        margin: EdgeInsets.all(8),
                                        height: 8,
                                        width: 8,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.black,
                                        ),
                                        margin: EdgeInsets.all(8),
                                        height: 6,
                                        width: 6,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border:
                                              Border.all(color: Colors.black),
                                          color: Colors.white,
                                        ),
                                        margin: EdgeInsets.all(8),
                                        height: 8,
                                        width: 8,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border:
                                              Border.all(color: Colors.black),
                                          color: Colors.white,
                                        ),
                                        margin: EdgeInsets.all(8),
                                        height: 8,
                                        width: 8,
                                      ),
                                    ],
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                    color: Colors.grey.shade600,
                                    spreadRadius: 0,
                                  ),
                                ],
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                    color: Colors.grey.shade600,
                                    spreadRadius: 0,
                                  ),
                                ],
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
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
