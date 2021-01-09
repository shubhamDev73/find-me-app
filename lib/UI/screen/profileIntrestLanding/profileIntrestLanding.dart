import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:findme/UI/Widgets/activityButtons.dart';
import 'package:findme/UI/Widgets/menuButton.dart';
import 'package:findme/data/models/intrests.dart';
import 'package:flutter/material.dart';
import 'package:findme/API.dart';

Future<List<Intrest>> fetchIntrests(Function callback) async {
  final response = await GET('me/interests/');

  if (response.statusCode == 200) {
    List<Intrest> intrests = jsonDecode(response.body)
        .map<Intrest>((intrest) => Intrest.fromJson(intrest))
        .toList();
    callback(intrests);
    return intrests;
  } else {
    throw Exception('Failed to load interests: ${response.statusCode}');
  }
}

Future<List<Intrest>> changeIntrests(Future<List<Intrest>> futureIntrests,
    int intrestId, int questionId, String answerText) async {
  List<Intrest> intrests = await futureIntrests;
  List<dynamic> questions = findIntrest(intrests, intrestId)?.questions;
  for (int i = 0; i < questions.length; i++) {
    if (questions[i]['id'] == questionId) {
      questions[i]['answer'] = answerText;
      break;
    }
  }
  return intrests;
}

void submitAnswer(String url, String body) async {
  final response = await POST(url, body, true);

  if (response.statusCode != 200)
    throw Exception('Failed to submit answer: ${response.statusCode}');
}

Intrest findIntrest(List<Intrest> intrests, int id) {
  for (int i = 0; i < intrests.length; i++) {
    if (intrests[i].id == id) {
      return intrests[i];
    }
  }
  return null;
}

FutureBuilder<List<Intrest>> createQuestions(
    Function onPageChange,
    Future<List<Intrest>> futureIntrests,
    int id,
    CarouselController buttonCarouselController) {
  return FutureBuilder<List<Intrest>>(
    future: futureIntrests,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        Intrest intrest = findIntrest(snapshot.data, id);
        if (intrest != null) {
          return CarouselSlider(
            carouselController: buttonCarouselController,
            items: intrest.questions
                .map((question) => Builder(
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
                    ))
                .toList(),
            options: CarouselOptions(
                initialPage: 0,
                // autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  onPageChange(intrest.questions[index]['id'],
                      intrest.questions[index]['answer']);
                }),
          );
        } else {
          return Text("Interest not found");
        }
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      // By default, show a loading spinner.
      return CircularProgressIndicator();
    },
  );
}

FutureBuilder<List<Intrest>> createIntrests(
    Function onClick, Future<List<Intrest>> futureIntrests, int id) {
  return FutureBuilder<List<Intrest>>(
    future: futureIntrests,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Column(
          children: getInterestList(snapshot.data),
          mainAxisAlignment: MainAxisAlignment.center,
        );
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      // By default, show a loading spinner.
      return CircularProgressIndicator();
    },
  );
}

List<Widget> getInterestList(List<Intrest> obj) {
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
    print("above");
    if (i % 2 == 0) {
      len_counter = 2;
      print(len_counter);
    } else {
      len_counter = 3;
      print(len_counter);
    }
    for (int j = 0; j < len_counter; j++) {
      dynamic intrest = obj[item_counter++];
      dynamic temp_button = ActivityButton(
        name: intrest.name,
        function: () {},
        amount: intrest.amount,
        selected: false,
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

  // for (int i = item_counter; i < obj.length; i++) {
  //   dynamic intrest = obj[item_counter++];
  //   dynamic temp_button = ActivityButton(
  //     name: intrest.name,
  //     function: () {},
  //     amount: intrest.amount,
  //     selected: false,
  //   );
  //   temp_row.add(temp_button);
  // }

  // Row temp_row_obj = Row(children: temp_row);
  // return_obj_col.add(temp_row_obj);
  // temp_row = [];

  return return_obj_col;
}

class ProfileIntrestLanding extends StatefulWidget {
  @override
  _ProfileIntrestLandingState createState() => _ProfileIntrestLandingState();
}

class _ProfileIntrestLandingState extends State<ProfileIntrestLanding> {
  Future<List<Intrest>> futureIntrests;

  int id = -1;
  int questionId = -1;
  String answer = '';

  @override
  void initState() {
    super.initState();
    futureIntrests = fetchIntrests((List<Intrest> intrests) {
      setState(() {
        Intrest intrest = findIntrest(intrests, id);
        questionId = intrest.questions[0]['id'];
        answer = intrest.questions[0]['answer'];
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
                  }, futureIntrests, id, buttonCarouselController),
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
                        futureIntrests = changeIntrests(
                            futureIntrests, id, questionId, text);
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
                child: createIntrests((int intrestId, String answerText) {
                  setState(() {
                    id = intrestId;
                    answer = answerText;
                  });
                }, futureIntrests, id),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/addUserIntrest');
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
            MenuButton(),
          ],
        ),
      ),
    );
  }
}

// SizedBox(
//   height: 12,
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, id, 0),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, id, 1),
//   ],
// ),
// SizedBox(
//   height: 8,
// ),
// Row(
//   mainAxisSize: MainAxisSize.max,
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, id, 2),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, id, 3),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, id, 4),
//   ],
// ),
// SizedBox(
//   height: 12,
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, id, 5),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, id, 6),
//   ],
// ),
// SizedBox(
//   height: 8,
// ),
// Row(
//   mainAxisSize: MainAxisSize.max,
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, id, 7),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, id, 8),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, id, 9),
//   ],
// ),
// SizedBox(
//   height: 8,
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, id, 10),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, id, 11),
//   ],
// ),
