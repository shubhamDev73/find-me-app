import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:findme/UI/Widgets/interestButton.dart';
import 'package:findme/UI/Widgets/misc.dart';
import 'package:findme/data/models/interests.dart';
import 'package:findme/data/models/user.dart';
import 'package:findme/API.dart';
import 'package:findme/globals.dart' as globals;

FutureBuilder<User> createQuestions(Function onPageChange, int interestId, CarouselController controller) {
  return createFutureWidget<User>(globals.futureUser, (User user) {
    Interest interest = findInterest(user.interests, interestId);
    return CarouselSlider(
      carouselController: controller,
      items: interest.questions.map((question) => Container(
        margin: EdgeInsets.symmetric(horizontal: 35),
        child: Center(
          child: Text(
            question['question'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      )).toList(),
      options: CarouselOptions(
          initialPage: 0,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          onPageChanged: (index, reason) {
            onPageChange(interest.questions[index]);
          }),
    );
  });
}

List<Widget> getInterestList(List<Interest> obj, Function onClick, int id) {

  int lenMod5 = obj.length ~/ 5;
  int renderLength = lenMod5 * 2;

  List<Widget> widgetList = [];
  List<Widget> tempRow = [];

  int itemCounter = 0;

  for (int i = 0; i < renderLength; i++) {
    for (int j = 0; j < i % 2 + 2; j++) {
      dynamic interest = obj[itemCounter++];
      tempRow.add(Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 7.0, 0.0, 7.0),
        child: InterestButton(
          name: interest.name,
          onClick: () {onClick(interest.id);},
          amount: interest.amount,
          selected: interest.id == id,
        ),
      ));
    }

    widgetList.add(Row(
      children: tempRow,
      mainAxisAlignment: MainAxisAlignment.center,
    ));
    tempRow = [];
  }

  for (int i = itemCounter; i < obj.length; i++) {
    dynamic interest = obj[itemCounter++];
    tempRow.add(Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 7.0, 0.0, 7.0),
      child: InterestButton(
        name: interest.name,
        onClick: () {onClick(interest.id);},
        amount: interest.amount,
        selected: interest.id == id,
      ),
    ));
  }

  widgetList.add(Row(
    children: tempRow,
    mainAxisAlignment: MainAxisAlignment.center,
  ));

  return widgetList;
}

void updateAnswer(int interestId, Map<String, dynamic> question, String answerText) async {
  POST('me/interests/$interestId/update/', jsonEncode([{"question": question['id'], "answer": answerText}]), true);
  int interestIndex;
  for (int i = 0; i < globals.user.interests.length; i++) {
    if (globals.user.interests[i].id == interestId) {
      interestIndex = i;
      break;
    }
  }
  Interest interest = globals.user.interests[interestIndex];
  for (int i = 0; i < interest.questions.length; i++) {
    if (interest.questions[i]['id'] == question['id']) {
      interest.questions[i]['answer'] = answerText;
      break;
    }
  }
  globals.user.interests[interestIndex] = interest;
  globals.getUser();
}

class ProfileInterestLanding extends StatefulWidget {
  @override
  _ProfileInterestLandingState createState() => _ProfileInterestLandingState();
}

class _ProfileInterestLandingState extends State<ProfileInterestLanding> {
  int interestId;
  Map<String, dynamic> question;

  @override
  void initState() {
    super.initState();
    globals.getUser(callback: (User user) {
      Interest interest = findInterest(user.interests, interestId);
      if(interest != null) setState(() {
        question = interest.questions[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (interestId == null) {
      interestId = ModalRoute.of(context).settings.arguments;
      if(globals.user != null) question = findInterest(globals.user.interests, interestId).questions[0];
    }

    CarouselController buttonCarouselController = CarouselController();
    TextEditingController answerController = new TextEditingController(text: question['answer']);

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
                  createQuestions((Map<String, dynamic> newQuestion) {
                    setState(() {
                      question = newQuestion;
                    });
                  }, interestId, buttonCarouselController),
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
                    child: TextField(
                      controller: answerController,
                      onSubmitted: (text) {updateAnswer(interestId, question, text);},
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                color: Color(0xfff0fbfd),
                child: createFutureWidget<User>(globals.futureUser, (User user) => Scrollbar(
                    child: ListView(
                      children: getInterestList(user.interests, (int newInterestId) {
                        setState(() {
                          interestId = newInterestId;
                          question = findInterest(globals.user.interests, interestId).questions[0];
                        });
                      }, interestId),
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    )
                )),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/addUserInterest');
              },
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
            MenuButton('me'),
          ],
        ),
      ),
    );
  }
}
