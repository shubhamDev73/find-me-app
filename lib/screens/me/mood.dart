import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/assets.dart';
import 'package:findme/models/user.dart';
import 'package:findme/globals.dart' as globals;

class HistoryItem extends StatelessWidget {
  HistoryItem({
    Key key,
    @required this.mood,
    @required this.parent,
  }) : super(key: key);

  final String mood;
  final _MoodSetState parent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          Assets.moods[mood]['weather'],
          //width: 50,
          height: 50,
        ),
        //Text(mood),
        Container(
          width: 1,
          height: 20,
          color: Colors.black,
        ),
      ],
    );
  }
}

class Mood extends StatefulWidget {

  final bool me;
  const Mood({this.me = true});

  @override
  _MoodState createState() => _MoodState();
}

class _MoodState extends State<Mood> {

  String mood = '';
  String currentmood = '';
  var moodHistory = ["Cheerful", "Mysterious", "Gloomy", "Angry"];
  int set;

  @override
  void initState() {
    super.initState();
    mood = 'Cheerful'; //FIXME: Set and Get from futureUser
    currentmood = mood;
    set = 1;
  }

  void _setMood(String a) {
    setState(() {
      mood = a;
      currentmood = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return createFutureWidget(globals.avatars.get(), (avatars) =>
        createFutureWidget(globals.getUser(me: widget.me), (User user) => Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      //color: Color(0xffE0F7FA),
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.more_vert),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: /*GestureDetector(
                  onTap: () {
                    //Navigator.of(context).pushNamed('/moodHistory');
                    setState(() {
                      set = (set == 1) ? 0 : 1;
                    });
                  },
                  child: */
                CarouselSlider(
                  options: CarouselOptions(
                    height: 100,
                    viewportFraction: 0.2,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    initialPage: moodHistory.length,
                    aspectRatio: 2.0,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        mood = (moodHistory + [currentmood])[index];
                        if(index != moodHistory.length) set = 0;
                        else set = 1;
                      });
                    }),
                  items: (moodHistory + [currentmood]).map((x) => Builder(
                    builder: (BuildContext context) => HistoryItem(
                      mood: x,
                      parent: this,
                    ),
                  )).toList(),
                ),
              ),
              //),
              Expanded(
                flex: 6,
                child: //Container(
                 Center(
                  //child: createAvatar(futureUser),
                  //Column(
                    child: Image(
                      image: AssetImage(Assets.moods[mood]['avatar']),
                      //width: 300,
                      //height: 300,
                    ),
                      //Text(mood),
                  ),
                //),
              ),
              //),
              Expanded(
                flex: 1,
                //child: Text(mood)
                child: Text(
                  user.nick,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Visibility(
                visible: set == 1,
                child: Expanded(
                  flex: 4,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: (avatars[user.baseAvatar]['avatars']).map((avatar) => Builder(
                      builder: (BuildContext context) => GestureDetector(
                        onTap: () => _setMood(avatar['mood']),
                        child: Column(
                          children: [
                            CachedNetworkImage(imageUrl: avatar['url']['v1'], width: 160),
                            Text(avatar['mood']),
                          ],
                        ),
                      ),
                    )).toList(),
                  ),
                ),
                replacement: SizedBox(
                  height: 200, // Some height
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text('felt '+ mood +' on (date)'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('(date)'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('FIXME: comment goes here'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
