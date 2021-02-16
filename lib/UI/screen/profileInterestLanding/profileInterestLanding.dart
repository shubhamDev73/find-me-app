import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:findme/UI/Widgets/interestButton.dart';
import 'package:findme/UI/Widgets/misc.dart';
import 'package:findme/data/models/interests.dart';
import 'package:flutter/material.dart';
import 'package:findme/API.dart';

Future<List<Interest>> changeInterests(Future<List<Interest>> futureInterests, int interestId, int questionId, String answerText) async {
  List<Interest> interests = await futureInterests;
  List<dynamic> questions = findInterest(interests, interestId)?.questions;
  for (int i = 0; i < questions.length; i++) {
    if (questions[i]['id'] == questionId) {
      questions[i]['answer'] = answerText;
      break;
    }
  }
  return interests;
}

void submitAnswer(String url, String body) async {
  final response = await POST(url, body, true);

  if (response.statusCode != 200)
    throw Exception('Failed to submit answer: ${response.statusCode}');
}

Interest findInterest(List<Interest> interests, int id) {
  for (int i = 0; i < interests.length; i++) {
    if (interests[i].id == id) {
      return interests[i];
    }
  }
  return null;
}

FutureBuilder<List<Interest>> createQuestions(Function onPageChange, Future<List<Interest>> futureInterests, int id, CarouselController controller) {
  return createFutureWidget<List<Interest>>(futureInterests, (List<Interest> interests) {
    Interest interest = findInterest(interests, id);
    if (interest != null) {
      return CarouselSlider(
        carouselController: controller,
        items: interest.questions.map((question) => Builder(
          builder: (BuildContext context) {
            return Container(
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
            );
          },
        )).toList(),
        options: CarouselOptions(
          initialPage: 0,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          onPageChanged: (index, reason) {
            onPageChange(interest.questions[index]['id'],
                interest.questions[index]['answer']);
          }),
      );
    } else {
      return Text("Interest not found");
    }
  });
}

List<Widget> getInterestList(List<Interest> obj, Function onClick, int id) {
  print("snapshot data lenght - ");
  print(obj.length);
  int len_mod5 = obj.length ~/ 5;
  int len_rem = obj.length - (len_mod5 * 5);
  int render_lenght = len_mod5 * 2;

  int len_counter = 3;
  int list_item_counter = 0;

  List<Widget> return_obj_col = [];
  // return_obj_col.add(Padding(padding: null))
  List<Widget> temp_row = [];

  int item_counter = 0;

  for (int i = 0; i < render_lenght; i++) {
    if (i % 2 == 0) {
      len_counter = 2;
    } else {
      len_counter = 3;
    }
    for (int j = 0; j < len_counter; j++) {
      dynamic interest = obj[item_counter++];
      dynamic temp_button = InterestButton(
        name: interest.name,
        onClick: () {onClick(interest.id, interest.questions[0]['answer']);},
        amount: interest.amount,
        selected: interest.id == id,
      );
      dynamic ob = Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 7.0, 0.0, 7.0),
        child: temp_button,
      );
      temp_row.add(ob);
    }
    Row temp_row_obj = Row(
      children: temp_row,
      mainAxisAlignment: MainAxisAlignment.center,
    );
    return_obj_col.add(temp_row_obj);
    temp_row = [];
  }

  for (int i = item_counter; i < obj.length; i++) {
    dynamic interest = obj[item_counter++];
    dynamic temp_button = InterestButton(
      name: interest.name,
      onClick: () {onClick(interest.id, interest.questions[0]['answer']);},
      amount: interest.amount,
      selected: interest.id == id,
    );
    dynamic ob = Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 7.0, 0.0, 7.0),
      child: temp_button,
    );
    temp_row.add(ob);
  }

  Row temp_row_obj = Row(
    children: temp_row,
    mainAxisAlignment: MainAxisAlignment.center,
  );
  return_obj_col.add(temp_row_obj);
  temp_row = [];

  return return_obj_col;
}

class ProfileInterestLanding extends StatefulWidget {
  @override
  _ProfileInterestLandingState createState() => _ProfileInterestLandingState();
}

class _ProfileInterestLandingState extends State<ProfileInterestLanding> {
  Future<List<Interest>> futureInterests;

  int id = -1;
  int questionId = -1;
  String answer = '';

  @override
  void initState() {
    super.initState();
    futureInterests = GETResponse<List<Interest>>('me/interests/',
      decoder: (result) => result.map<Interest>((interest) => Interest.fromJson(interest)).toList(),
      callback: (List<Interest> interests) {
        setState(() {
          Interest interest = findInterest(interests, id);
          questionId = interest.questions[0]['id'];
          answer = interest.questions[0]['answer'];
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (id == -1) {
      setState(() {
        id = ModalRoute.of(context).settings.arguments;
      });
    }

    CarouselController buttonCarouselController = CarouselController();
    TextEditingController answerController =
    new TextEditingController(text: answer);

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
                  createQuestions((int id, String answerText) {
                    setState(() {
                      questionId = id;
                      answer = answerText;
                    });
                  }, futureInterests, id, buttonCarouselController),
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
                      onSubmitted: (text) {
                        submitAnswer(
                            'me/interests/$id/update/',
                            jsonEncode([
                              {"question": questionId, "answer": text}
                            ]));
                        futureInterests = changeInterests(
                            futureInterests, id, questionId, text);
                      },
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
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                color: Color(0xfff0fbfd),
                child: createFutureWidget<List<Interest>>(futureInterests, (List<Interest> interests) => Scrollbar(
                  child: ListView(
                    children: getInterestList(interests, (int interestId, String answerText) {
                      setState(() {
                        id = interestId;
                        answer = answerText;
                      });
                    }, id),
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  ),
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
