import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:findme/widgets/interestButton.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/models/user.dart';
import 'package:findme/globals.dart' as globals;

class QuestionsWidget extends StatefulWidget {

  final List<dynamic> questions;
  final bool me;
  final int interestId;
  QuestionsWidget({this.me, this.interestId, this.questions});

  @override
  _QuestionsWidgetState createState() => _QuestionsWidgetState();
}

class _QuestionsWidgetState extends State<QuestionsWidget> {

  CarouselController buttonCarouselController = CarouselController();
  Map<String, dynamic> currentQuestion;

  @override
  void initState() {
    super.initState();
    currentQuestion = widget.questions[0];
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.questions.contains(currentQuestion)) currentQuestion = widget.questions[0];
    TextEditingController answerController = TextEditingController(text: currentQuestion['answer']);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider(
                carouselController: buttonCarouselController,
                items: widget.questions.map((question) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
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
                  autoPlay: false,
                  scrollDirection: Axis.horizontal,
                  enableInfiniteScroll: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) => setState(() {
                    currentQuestion = widget.questions[index];
                  }),
                ),
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
                          curve: Curves.decelerate,
                        ),
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
                          curve: Curves.decelerate,
                        ),
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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 80, vertical: 0),
          child: widget.me ? TextField(
            controller: answerController,
            onSubmitted: (text) => updateAnswer(widget.interestId, currentQuestion['id'], text),
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ) :
          Text(
            currentQuestion['answer'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.questions.map((question) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: question['id'] == currentQuestion['id'] ? null : Border.all(color: Colors.black),
                  color: question['id'] == currentQuestion['id'] ? Colors.black : Colors.white,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void updateAnswer(int interestId, int questionId, String answer) {
    globals.addPostCall(
      'me/interests/$interestId/update/',
      {"question": questionId, "answer": answer},
      overwrite: (body) => body['question'] == questionId,
    );

    globals.meUser.update((User user) {
      Interest interest = user.interests[interestId];
      for (int i = 0; i < interest.questions.length; i++) {
        if (interest.questions[i]['id'] == questionId) {
          interest.questions[i]['answer'] = answer;
          break;
        }
      }
      user.interests[interestId] = interest;
      return user;
    });
  }

}

List<Widget> getInterestList(List<Interest> obj, Function onClick, int id) {

  List<Widget> widgetList = [];
  int itemCounter = 0;

  for(int i = 0; i <= (obj.length ~/ 5) * 2; i++){
    List<Widget> tempRow = [];
    for(int j = 0; j < i % 2 + 2; j++){
      if(itemCounter >= obj.length) break;
      Interest interest = obj[itemCounter++];
      tempRow.add(InterestButton(
        name: interest.name,
        onClick: () => onClick(interest.id),
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
  }

  return widgetList;
}

class Interests extends StatefulWidget {

  final bool me;
  const Interests({this.me = true});

  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {

  int interestId;

  @override
  void initState() {
    super.initState();
    if(widget.me) globals.onUserChanged['interests'] = () => setState(() {});
  }

  @override
  void dispose() {
    if(widget.me) globals.onUserChanged.remove('interests');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (interestId == null) interestId = ModalRoute.of(context).settings.arguments;

    return createFutureWidget<User>(globals.getUser(me: widget.me), (User user) {
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
                child: QuestionsWidget(me: widget.me, interestId: interestId, questions: user.interests[interestId].questions),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 17.0, 0.0, 0.0),
                  color: Color(0xfff0fbfd),
                  child: ListView(
                    children: getInterestList(user.interests.values.toList(), (int newInterestId) => setState(() {
                      interestId = newInterestId;
                    }), interestId),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              widget.me ? GestureDetector(
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
              ) :
              Container(),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      );
    });
  }
}
