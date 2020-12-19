import 'dart:convert';

import 'package:findme/data/models/intrests.dart';

class User {
  String nick;
  String avatar;
  String personality;
  List<Intrest> intrests;
  String mood;

  User({
    this.nick,
    this.avatar,
    this.personality,
    this.intrests,
    this.mood,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    nick: json["nick"],
    avatar: json["avatar"],
    personality: "",//json["personality"],
    intrests: json["interests"].map<Intrest>((intrest) => Intrest.fromJson(intrest)).toList(),
    mood: json["mood"],
  );

  Map<String, dynamic> toJson() =>
      {
        "nick": nick,
        "avatar": avatar,
        "personality": personality,
        "interests": intrests.map((intrest) => intrest.toJson()).toList(),
        "mood": mood,
      };

}
