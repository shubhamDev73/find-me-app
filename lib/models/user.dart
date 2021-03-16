import 'dart:collection';

import 'package:findme/models/interests.dart';

class User {
  String nick;
  Map<String, dynamic> avatar;
  Map<String, dynamic> personality;
  LinkedHashMap<int, Interest> interests;
  String mood;

  User({
    this.nick,
    this.avatar,
    this.personality,
    this.interests,
    this.mood,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    nick: json["nick"],
    avatar: json["avatar"],
    personality: json["personality"],
    interests: LinkedHashMap.fromIterable(json["interests"], key: (interest) => interest['id'], value: (interest) => Interest.fromJson(interest)),
    mood: json["mood"],
  );

  Map<String, dynamic> toJson() =>
    {
      "nick": nick,
      "avatar": avatar,
      "personality": personality,
      "interests": interests.values.map((value) => value.toJson()).toList(),
      "mood": mood,
    };

}
