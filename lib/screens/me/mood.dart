import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:findme/assets.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/user.dart';
import 'package:findme/globals.dart' as globals;

class HistoryItem extends StatelessWidget {

  final String icon;

  HistoryItem({this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.network(icon, width: 50),
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

  String mood;
  bool isTimeline;
  DateTime timestamp;
  final CarouselController timelineController = new CarouselController();

  @override
  void initState() {
    super.initState();
    isTimeline = false;
    if(widget.me) globals.onUserChanged['mood'] = () => setState(() {});
    globals.onAvatarsChanged = () => setState(() {});
    globals.onMoodsChanged = () => setState(() {});
  }

  @override
  void dispose() {
    if(widget.me) globals.onUserChanged.remove('mood');
    globals.onAvatarsChanged = null;
    globals.onMoodsChanged = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globals.avatars.get();
    globals.moods.get();
    return createFutureWidget(globals.avatars.get(), (avatars) =>
      createFutureWidget(globals.moods.get(), (moods) =>
        createFutureWidget(globals.getUser(me: widget.me), (User user) {
          if (mood == null) mood = user.mood;
          return Scaffold(
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
                    child: CarouselSlider(
                      carouselController: timelineController,
                      options: CarouselOptions(
                        height: 100,
                        viewportFraction: 0.2,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        initialPage: user.timeline.length,
                        aspectRatio: 2.0,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) => setState(() {
                          mood = user.timeline[index]['mood'];
                          timestamp = DateTime.parse(user.timeline[index]['timestamp']);
                          isTimeline = (index != user.timeline.length - 1);
                        }),
                      ),
                      items: user.timeline.map((timeline) => Builder(
                        builder: (BuildContext context) => HistoryItem(
                          icon: moods[timeline['mood']]['url']['icon'],
                        ),
                      )).toList(),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        Container(
                          height: 190,
                          width: 190,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                child: Center(
                                  child: CachedNetworkImage(
                                    imageUrl: avatars[user.baseAvatar]['avatars'][mood]['url']['v2'],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 165,
                                child: SvgPicture.asset(
                                  Assets.edit,
                                  height: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          user.nick,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !isTimeline,
                    child: Expanded(
                      flex: 4,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: (avatars[user.baseAvatar]['avatars'].values).map<Widget>((avatar) => Builder(
                          builder: (BuildContext context) => GestureDetector(
                            onTap: () {
                              globals.addPostCall('me/avatar/update/', {"id": avatar['id']});
                              setState(() {
                                mood = avatar['mood'];
                              });
                              globals.meUser.update((user) {
                                user.mood = avatar['mood'];
                                user.avatar = avatar['url'];
                                user.timeline.add({
                                  "timestamp": DateTime.now().toString(),
                                  "mood": avatar['mood'],
                                  "base_avatar": user.baseAvatar,
                                });
                                SchedulerBinding.instance.addPostFrameCallback((timeStamp) =>
                                  timelineController.animateToPage(user.timeline.length, duration: Duration(milliseconds: 100))
                                );
                                return user;
                              });
                            },
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
                            child: Text('felt ' + mood + ' ' + formatDate(endDate: timestamp)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(formatDate(timestamp: timestamp)),
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
          );
        }),
      ),
    );
  }
}
