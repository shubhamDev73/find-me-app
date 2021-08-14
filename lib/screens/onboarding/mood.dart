import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:findme/widgets/topBox.dart';
import 'package:findme/widgets/misc.dart';
import 'package:findme/globals.dart' as globals;

class MoodItem extends StatelessWidget {

  final Map<String, dynamic> avatar;
  final void Function() onTap;
  MoodItem({required this.avatar, required this.onTap});

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

  @override
  _MoodState createState() => _MoodState();
}

class _MoodState extends State<Mood> {

  String mood = 'Cheerful';
  String baseAvatar = 'Panda';
  bool animalSelected = false;
  bool moodSelected = false;
  final CarouselController moodController = new CarouselController();

  @override
  Widget build(BuildContext context) {
    return createFutureWidget(globals.avatars.get(), (Map<String, dynamic> avatars) {
      Map<String, dynamic> userAvatars = avatars[baseAvatar]['avatars'];
      List<dynamic> avatarList = userAvatars.values.toList();
      return Scaffold(
        body: Column(
          children: [
            TopBox(
              height: 208,
              title: animalSelected ? 'slide to select your mood' : 'tap to select your spirit',
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: avatars.values.map((avatar) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      baseAvatar = avatar['name'];
                      animalSelected = true;
                      globals.addPostCall('me/avatar/update/', {"id": avatar['id']}, overwrite: (body) => true);
                      globals.meUser.update((user) {
                        user.baseAvatar = baseAvatar;
                        user.avatar = avatar['avatars'][mood]['url'];
                        return user;
                      });
                    }),
                    child: CachedNetworkImage(
                      imageUrl: avatar['url'],
                      width: 30,
                    ),
                  ),
                )).toList(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Container(
                    height: 190,
                    width: 190,
                    child: animalSelected ? Container(
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: userAvatars[mood]['url']['v2'],
                        ),
                      ),
                    ) : Container(),
                  ),
                  SizedBox(height: 50),
                  moodSelected ? Button(
                    text: "Done",
                    onTap: () {
                      globals.onboardingCallbacks['mood']?.call();
                      Navigator.of(context).pop();
                    },
                  ) : Container(),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: animalSelected ? Carousel(
                controller: moodController,
                items: avatarList,
                widget: (avatar) => MoodItem(
                  avatar: avatar,
                  onTap: () => moodController.animateToPage(avatarList.indexOf(avatar)),
                ),
                onPageChanged: (index, reason) {
                  Map<String, dynamic> avatar = avatarList[index];

                  globals.addPostCall('me/avatar/update/', {"id": avatar['id']}, overwrite: (body) => true);
                  setState(() {
                    mood = avatar['mood'];
                    moodSelected = true;
                  });

                  globals.meUser.update((user) {
                    user.mood = avatar['mood'];
                    user.avatar = avatar['url'];
                    return user;
                  });
                },
                elementsToDisplay: 3,
                initialPage: avatarList.indexWhere((avatar) => avatar['mood'] == mood),
                gap: 1000,
              ) : Container(),
            ),
          ],
        ),
      );
    });
  }
}
