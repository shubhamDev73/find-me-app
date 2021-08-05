import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:findme/widgets/misc.dart';
import 'package:findme/models/user.dart';
import 'package:findme/globals.dart' as globals;
import 'package:findme/events.dart' as events;

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
    return createFutureWidget(globals.avatars.get(), (Map<String, dynamic> avatars) =>
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
                          events.sendEvent('avatarSelect', {"avatar": avatar['name']});
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
                  child: widget.me ? Carousel(
                    controller: moodController,
                    items: avatarList,
                    widget: (avatar) => MoodItem(
                      avatar: avatar,
                      onTap: () => moodController.animateToPage(avatarList.indexOf(avatar)),
                    ),
                    onPageChanged: (index, reason) {
                      Map<String, dynamic> avatar = avatarList[index];

                      globals.addPostCall('me/avatar/update/', {"id": avatar['id']});
                      setState(() {
                        mood = avatar['mood'];
                      });

                      globals.meUser.update((user) {
                        user.mood = avatar['mood'];
                        user.avatar = avatar['url'];
                        return user;
                      });
                      events.sendEvent('moodSelect', {"mood": avatar['mood']});
                    },
                    elementsToDisplay: 3,
                    initialPage: avatarList.indexWhere((avatar) => avatar['mood'] == user.mood),
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
    );
  }
}
