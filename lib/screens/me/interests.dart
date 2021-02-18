import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:findme/widgets/interestButton.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/models/user.dart';
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
              fontSize: 28,
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
      tempRow.add(InterestButton(
        name: interest.name,
        onClick: () {onClick(interest.id);},
        amount: interest.amount,
        selected: interest.id == id,
      ));
      if(j != i % 2 + 1)
        tempRow.add(SizedBox(width: 12));
    }

    widgetList.add(Row(
      children: tempRow,
      mainAxisAlignment: MainAxisAlignment.center,
    ));
    widgetList.add(SizedBox(height: 20));
    tempRow = [];
  }

  for (int i = itemCounter; i < obj.length; i++) {
    dynamic interest = obj[itemCounter++];
    tempRow.add(Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 10.0, 0.0, 7.0),
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

class Interests extends StatefulWidget {
  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
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
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 80, vertical: 0),
                    child: TextField(
                      controller: answerController,
                      onSubmitted: (text) {updateAnswer(interestId, question, text);},
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 27),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 17.0, 0.0, 0.0),
                color: Color(0xfff0fbfd),
                child: createFutureWidget<User>(globals.futureUser, (User user) => Scrollbar(
                    child: ListView(
                      children: getInterestList(user.interests, (int newInterestId) {
                        setState(() {
                          interestId = newInterestId;
                          question = findInterest(globals.user.interests, interestId).questions[0];
                        });
                      }, interestId),
                    )
                )),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/interests/add');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 7),
                child: Text(
                  "+ Interests",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
