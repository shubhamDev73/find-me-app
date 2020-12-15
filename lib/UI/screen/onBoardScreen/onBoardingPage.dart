import 'dart:io';

import 'package:findme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:findme/data/models/onBoardingModel.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<SliderModel> mySLides = new List<SliderModel>();
  int slideIndex = 0;
  PageController controller;
  @override
  void initState() {
    super.initState();
    mySLides = getSlides();
    controller = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildPageIndicator(bool isCurrentPage) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        height: isCurrentPage ? 10.0 : 6.0,
        width: isCurrentPage ? 10.0 : 6.0,
        decoration: BoxDecoration(
          color: isCurrentPage ? Colors.white : Colors.transparent,
          border: isCurrentPage
              ? Border.all(color: Colors.transparent)
              : Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            MyColors.primaryColor,
          ],
        )),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    slideIndex = index;
                  });
                },
                children: <Widget>[
                  SlideTile(
                    imagePath: mySLides[0].getImageAssetPath(),
                    title: mySLides[0].getTitle(),
                    desc: mySLides[0].getDesc(),
                  ),
                  SlideTile(
                    imagePath: mySLides[1].getImageAssetPath(),
                    title: mySLides[1].getTitle(),
                    desc: mySLides[1].getDesc(),
                  ),
                  SlideTile(
                    imagePath: mySLides[2].getImageAssetPath(),
                    title: mySLides[2].getTitle(),
                    desc: mySLides[2].getDesc(),
                    isLast: true,
                  )
                ],
              ),
            ),
            Expanded(
                flex: slideIndex != 2 ? 1 : 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    slideIndex != 2
                        ? Container()
                        : Column(
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context)
                                    .pushNamed("/register"),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    "sign up",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.primaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    Navigator.of(context).pushNamed("/login"),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14)),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    "login",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: MyColors.primaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 3; i++)
                          i == slideIndex
                              ? _buildPageIndicator(true)
                              : _buildPageIndicator(false),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    slideIndex != 2
                        ? GestureDetector(
                            onTap: () {
                              controller.animateToPage(2,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.linear);
                            },
                            child: Text(
                              "skip >",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          )
                        : Container(),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  final String imagePath, title, desc;
  final bool isLast;

  SlideTile({this.imagePath, this.title, this.desc, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment:
            isLast ? MainAxisAlignment.end : MainAxisAlignment.center,
        children: [
          Hero(
            tag: "logo",
            child: SvgPicture.asset(
              imagePath,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Hero(
            tag: "title",
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
          Hero(
            tag: "desc",
            child: Text(
              desc,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
