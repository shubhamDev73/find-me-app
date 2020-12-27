import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:findme/UI/Widgets/activityButtons.dart';
import 'package:findme/UI/Widgets/menuButton.dart';
import 'package:findme/data/models/intrests.dart';
import 'package:flutter/material.dart';
import 'package:findme/API.dart';

Future<List<Intrest>> fetchIntrests(Function callback) async {
  final response = await GET('me/interests');

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

<<<<<<< Updated upstream
=======
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

>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                  onPageChange(intrest.questions[index]['answer']);
=======
                  onPageChange(intrest.questions[index]['id'],
                      intrest.questions[index]['answer']);
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
FutureBuilder<List<Intrest>> createIntrest(
    Function onClick, Future<List<Intrest>> futureIntrests) {
=======
FutureBuilder<List<Intrest>> createIntrests(
    Function onClick, Future<List<Intrest>> futureIntrests, int id) {
>>>>>>> Stashed changes
  return FutureBuilder<List<Intrest>>(
    future: futureIntrests,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<Intrest> int_list_obj = new List(snapshot.data.length);

        print("####################################################");
        print(snapshot.data[0].name);

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return Container(
              color: Color(0xffE0F7FA),
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ActivityButton(
                name: snapshot.data[index].name,
                function: () {
                  onClick(snapshot.data[index].id,
                      snapshot.data[index].questions[0]['answer']);
                },
                amount: snapshot.data[index].amount,
              ),
            );
          },
        );
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      // By default, show a loading spinner.
      return CircularProgressIndicator();
    },
  );
}

class ProfileIntrestLanding extends StatefulWidget {
  @override
  _ProfileIntrestLandingState createState() => _ProfileIntrestLandingState();
}

class _ProfileIntrestLandingState extends State<ProfileIntrestLanding> {
  Future<List<Intrest>> futureIntrests;

  int id = -1;
  String answer = '';

  @override
  void initState() {
    super.initState();
    futureIntrests = fetchIntrests((List<Intrest> intrests) {
      setState(() {
<<<<<<< Updated upstream
        answer = findIntrest(intrests, id).questions[0]['answer'];
=======
        Intrest intrest = findIntrest(intrests, id);
        questionId = intrest.questions[0]['id'];
        answer = intrest.questions[0]['answer'];
>>>>>>> Stashed changes
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (id == -1) id = ModalRoute.of(context).settings.arguments;
    });
    CarouselController buttonCarouselController = CarouselController();
<<<<<<< Updated upstream
=======
    TextEditingController answerController =
        new TextEditingController(text: answer);

>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                  createQuestions((String answerText) {
                    setState(() {
=======
                  createQuestions((int id, String answerText) {
                    setState(() {
                      questionId = id;
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                    child: Text(
                      answer,
=======
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
>>>>>>> Stashed changes
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
                child: createIntrest((int intrestId, String answerText) {
                  setState(() {
                    id = intrestId;
                    answer = answerText;
                  });
                }, futureIntrests),
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
//     }, futureIntrests, 0),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, 1),
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
//     }, futureIntrests, 2),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, 3),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, 4),
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
//     }, futureIntrests, 5),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, 6),
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
//     }, futureIntrests, 7),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, 8),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, 9),
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
//     }, futureIntrests, 10),
//     SizedBox(
//       width: 12,
//     ),
//     createIntrest((int intrestId, String answerText) {
//       setState(() {
//         id = intrestId;
//         answer = answerText;
//       });
//     }, futureIntrests, 11),
//   ],
// ),
