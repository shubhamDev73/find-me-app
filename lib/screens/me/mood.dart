import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CachedNetworkImage(imageUrl: avatar['url']['v1'], height: 120),
          Text(avatar['mood'], style: TextStyle(fontSize: 18)),
        ],
      ),
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
  final CarouselController moodController = new CarouselController();

  @override
  void initState() {
    super.initState();
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
    return createFutureWidget(globals.avatars.get(), (Map<String, dynamic> avatars) =>
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: widget.me ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: avatars.values.map((avatar) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            Map<String, dynamic> moodAvatar = avatar['avatars'][user.mood];
                            globals.meUser.update((user) {
                              user.avatar = moodAvatar['url'];
                              user.baseAvatar = avatar['name'];
                              globals.addPostCall('me/avatar/update/', {"id": moodAvatar['id']});
                              return user;
                            });
                            SchedulerBinding.instance.addPostFrameCallback((timeStamp) =>
                                moodController.jumpToPage(avatar['avatars'].values.toList().indexWhere((avatar) => avatar['mood'] == user.mood))
                            );
                          }),
                          child: CachedNetworkImage(
                            imageUrl: avatar['url'],
                            width: 30,
                          ),
                        ),
                      )).toList(),
                    ) : Container(),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Container(
                          height: 190,
                          width: 190,
                          child: Container(
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: userAvatars[mood]['url']['v2'],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          user.nick,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        widget.me ? Container() : Text(
                          "is feeling",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: widget.me ? Stack(
                      children: [
                        CarouselSlider(
                          carouselController: moodController,
                          options: CarouselOptions(
                            height: 300,
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
                                globals.addPostCall('me/avatar/update/', {"id": avatar['id']});
                                return user;
                              });
                            },
                          ),
                          items: avatarList.map<Widget>((avatar) => MoodItem(
                            avatar: avatar,
                            onTap: () => moodController.animateToPage(avatarList.indexOf(avatar)),
                          )).toList(),
                        ),
                        Positioned(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: GestureDetector(
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
                                child: GestureDetector(
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
                    ) : Text(
                      user.mood,
                      style: TextStyle(
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
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
