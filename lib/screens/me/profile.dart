import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:findme/assets.dart';
import 'package:findme/widgets/topBox.dart';
import 'package:findme/widgets/traitBar.dart';
import 'package:findme/widgets/userInfo.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/widgets/interestButton.dart';
import 'package:findme/models/user.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/globals.dart' as globals;
import 'package:findme/events.dart' as events;

class Profile extends StatefulWidget {

  final bool me;
  const Profile({this.me = true});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();
    if(widget.me) globals.onUserChanged['profile'] = () => setState(() {});
  }

  @override
  void dispose() {
    if(widget.me) globals.onUserChanged.remove('profile');
    super.dispose();
  }

  Widget createInterest(User user, BuildContext context, int index) {
    List<Interest> interests = user.interests.values.toList();
    if(index == 4){
      return InterestButton(
        name: Assets.plus,
        isSvg: true,
        selected: true,
        onClick: () {
          Navigator.of(context).pushNamed('/interests', arguments: interests[0].id);
          events.sendEvent('interestSelect', {"interest": 0, "home": true});
        },
      );
    }else{
      Interest interest = index < interests.length ? interests[index] : new Interest(id: interests[0].id, name: '', amount: 0, questions: List.empty());
      return InterestButton(
        name: interest.name,
        amount: interest.amount!,
        onClick: () {
          Navigator.of(context).pushNamed('/interests', arguments: interest.id);
          events.sendEvent('interestSelect', {"interest": interest.id, "home": true});
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return createFutureWidget<User>(globals.getUser(me: widget.me), (User user) => Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: TopBox(
              title: "Konichiwa",
              description: "Did you know the US armys traning bumbelbees to sniff out explosive?",
              settings: widget.me,
              widget: TraitsElements(
                onClick: (String trait) {
                  Navigator.of(context).pushNamed('/personality', arguments: trait);
                  events.sendEvent('traitSelect', {"trait": trait, "home": true});
                },
                personality: user.personality,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/mood');
                events.sendEvent('avatarClick');
              },
              child: UserInfo(user),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    createInterest(user, context, 0),
                    SizedBox(width: 12),
                    createInterest(user, context, 1),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    createInterest(user, context, 2),
                    SizedBox(width: 12),
                    createInterest(user, context, 3),
                    SizedBox(width: 12),
                    createInterest(user, context, 4),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Button(
                  text: widget.me ? "Feedback" : "Talk",
                  onTap: () async {
                    if(widget.me){
                      String url = '';
                      if(await canLaunch(url)) await launch(url);
                      events.sendEvent('feedbackClick');
                    }else{
                      Navigator.of(context).pushNamed('/message', arguments: ModalRoute.of(context)!.settings.arguments);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
