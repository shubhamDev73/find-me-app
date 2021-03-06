import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:findme/assets.dart';
import 'package:findme/constant.dart';
import 'package:findme/widgets/interestButton.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/models/user.dart';
import 'package:findme/globals.dart' as globals;
import 'package:findme/events.dart' as events;

class QuestionsWidget extends StatelessWidget {

  final List<dynamic> questions;
  final bool me;
  final int interestId;
  QuestionsWidget({required this.me, required this.interestId, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Carousel(
      items: questions,
      widget: (question) {
        TextEditingController answerController = TextEditingController(text: question['answer']);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                question['question'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 60),
              child: me ? TextField(
                textInputAction: TextInputAction.send,
                controller: answerController,
                onSubmitted: (text) => updateAnswer(interestId, question['id'], text),
                textAlign: TextAlign.center,
                maxLines: null,
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ) :
              Text(
                answerController.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
      onPageChanged: (index, reason) {
        events.sendEvent('questionSelect', {"question": questions[index]['id']}, me);
      },
      gap: 300,
    );
  }

  void updateAnswer(int interestId, int questionId, String answer) {
    globals.addPostCall(
      'me/interests/$interestId/update/',
      {"question": questionId, "answer": answer},
      overwrite: (body) => body['question'] == questionId,
    );

    globals.meUser.update((User user) {
      Interest interest = user.interests[interestId]!;
      for (int i = 0; i < interest.questions.length; i++) {
        if (interest.questions[i]['id'] == questionId) {
          interest.questions[i]['answer'] = answer;
          break;
        }
      }
      user.interests[interestId] = interest;
      return user;
    });
    events.sendEvent('questionAnswer', {"question": questionId});
  }

}

List<Widget> getInterestList(List<Interest> obj, Function onClick, int id) {

  List<Widget> widgetList = [SizedBox(height: 17)];
  int itemCounter = 0;

  int elementsInRow = 2;
  while(itemCounter < obj.length){
    List<Widget> tempRow = List.empty(growable: true);
    for(int j = 0; j < elementsInRow; j++){
      if(itemCounter >= obj.length) break;
      Interest interest = obj[itemCounter++];
      tempRow.add(InterestButton(
        name: interest.name,
        onClick: () => onClick(interest.id),
        amount: interest.amount!,
        selected: interest.id == id,
      ));
      if(j != elementsInRow - 1 && itemCounter != obj.length)
        tempRow.add(SizedBox(width: 12));
    }

    widgetList.add(Row(
      children: tempRow,
      mainAxisAlignment: MainAxisAlignment.center,
    ));
    widgetList.add(SizedBox(height: 20));
    elementsInRow = elementsInRow == 2 ? 3 : 2;
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

  int? interestId;

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
    if (interestId == null) interestId = ModalRoute.of(context)!.settings.arguments as int;

    return createFutureWidget<User>(globals.getUser(me: widget.me), (User user) {
      if(!user.interests.containsKey(interestId)) interestId = user.interests.values.elementAt(0).id;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Button(type: 'back'),
            Expanded(
              flex: 6,
              child: QuestionsWidget(me: widget.me, interestId: interestId!, questions: user.interests[interestId]!.questions),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                color: ThemeColors.lightColor,
                child: ThemeScrollbar(
                  child: ListView(
                    children: getInterestList(user.interests.values.toList(), (int newInterestId) => setState(() {
                      interestId = newInterestId;
                      events.sendEvent('interestSelect', {"interest": interestId}, widget.me);
                    }), interestId!),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            widget.me ? Button(
              text: "+ Interests",
              onTap: () {
                Navigator.of(context).pushNamed('/interests/add');
                events.sendEvent('addInterestsClick');
              },
            ) : Container(),
            SizedBox(height: 15),
          ],
        ),
      );
    });
  }
}
