import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:findme/assets.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/models/user.dart';
import 'package:findme/globals.dart' as globals;

class TimelineItem extends StatelessWidget {

  final String icon;

  TimelineItem({this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.network(icon, width: 50),
        SizedBox(height: 10),
        Container(
          width: 1.5,
          height: 16,
          color: Colors.grey.shade500,
        ),
      ],
    );
  }
}

class MoodItem extends StatelessWidget {

  final Map<String, dynamic> avatar;
  final Function onTap;
  MoodItem({this.avatar, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            width: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
        ),
        Column(
          children: [
            CachedNetworkImage(imageUrl: avatar['url']['v1'], width: 160),
            Text(avatar['mood']),
          ],
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
  final CarouselController moodController = new CarouselController();

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
          if(mood == null) mood = user.mood;
          Map<String, dynamic> userAvatars = avatars[user.baseAvatar]['avatars'];
          List<Map<String, dynamic>> avatarList = userAvatars.values.toList();
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
                    flex: 2,
                    child: CarouselSlider(
                      carouselController: timelineController,
                      options: CarouselOptions(
                        height: 100,
                        viewportFraction: 0.18,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        initialPage: user.timeline.length,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) => setState(() {
                          mood = user.timeline[index]['mood'];
                          timestamp = DateTime.parse(user.timeline[index]['timestamp']);
                          isTimeline = (index != user.timeline.length - 1);
                        }),
                      ),
                      items: user.timeline.map((timeline) => Builder(
                        builder: (BuildContext context) => TimelineItem(
                          icon: moods[timeline['mood']]['url']['icon'],
                        ),
                      )).toList(),
                    ),
                  ),
                  Expanded(
                    flex: 4,
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
                                    imageUrl: userAvatars[mood]['url']['v2'],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 165,
                                child: SvgPicture.asset(
                                  Assets.edit,
                                  width: 25,
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
                  Expanded(
                    flex: 4,
                    child: Stack(
                      children: [
                        Offstage(
                          offstage: !widget.me || isTimeline,
                          child: widget.me ? Stack(
                            children: [
                              CarouselSlider(
                                carouselController: moodController,
                                options: CarouselOptions(
                                  height: 180,
                                  viewportFraction: 0.3,
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll: true,
                                  initialPage: avatarList.indexWhere((avatar) => avatar['mood'] == user.mood),
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason) {
                                    Map<String, dynamic> avatar = avatarList[index];

                                    setState(() {
                                      mood = avatar['mood'];
                                    });

                                    globals.meUser.update((user) {
                                      user.mood = avatar['mood'];
                                      user.avatar = avatar['url'];

                                      Map<String, dynamic> lastTimeline = user.timeline[user.timeline.length - 1];
                                      Duration diff = DateTime.now().difference(DateTime.parse(lastTimeline['timestamp']));
                                      if(diff.inDays > 0 || diff.inHours >= 4){
                                        user.timeline.add({
                                          "timestamp": DateTime.now().toString(),
                                          "mood": avatar['mood'],
                                          "base_avatar": user.baseAvatar,
                                        });
                                        SchedulerBinding.instance.addPostFrameCallback((timeStamp) =>
                                          timelineController.animateToPage(user.timeline.length - 1, duration: Duration(milliseconds: 100))
                                        );
                                        globals.addPostCall('me/avatar/update/', {"id": avatar['id']});
                                      }else{
                                        lastTimeline['mood'] = avatar['mood'];
                                        lastTimeline['base_avatar'] = user.baseAvatar;
                                      }

                                      return user;
                                    });
                                  },
                                ),
                                items: (avatarList).map<Widget>((avatar) => MoodItem(
                                  avatar: avatar,
                                )).toList(),
                              ),
                              Positioned(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: InkWell(
                                        onTap: () => moodController.previousPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.decelerate,
                                        ),
                                        child: Container(
                                          child: Center(
                                            child: Icon(Icons.arrow_back_ios),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12.0),
                                      child: InkWell(
                                        onTap: () => moodController.nextPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.decelerate,
                                        ),
                                        child: Container(
                                          child: Center(
                                            child: Icon(Icons.arrow_forward_ios),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ) : Container(),
                        ),
                        Offstage(
                          offstage: widget.me && !isTimeline,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 50),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  isTimeline ? 'felt ' + mood.toLowerCase() + ' on'
                                  : 'is feeling ' + mood.toLowerCase()
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: isTimeline ? Text(
                                  formatDate(timestamp: timestamp),
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ) : Container(),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('FIXME: comment goes here'),
                              ),
                            ],
                          ),
                        ),
                      ],
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
