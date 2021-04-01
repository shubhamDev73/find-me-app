import 'dart:collection';

import 'package:findme/models/interests.dart';

class User {
  String nick;
  String baseAvatar;
  Map<String, dynamic> avatar;
  Map<String, dynamic> personality;
  LinkedHashMap<int, Interest> interests;
  String mood;
  List<dynamic> timeline;

  User({
    this.nick,
    this.baseAvatar,
    this.avatar,
    this.personality,
    this.interests,
    this.mood,
    this.timeline,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    json['interests'].sort((dynamic a, dynamic b) => DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
    return User(
      nick: json["nick"],
      baseAvatar: json["base_avatar"],
      avatar: json["avatar"],
      personality: json["personality"],
      interests: LinkedHashMap.fromIterable(json["interests"], key: (interest) => interest['id'], value: (interest) => Interest.fromJson(interest)),
      mood: json["mood"],
      timeline: json["avatar_timeline"],
    );
  }

  Map<String, dynamic> toJson() =>
    {
      "nick": nick,
      "base_avatar": baseAvatar,
      "avatar": avatar,
      "personality": personality,
      "interests": interests.values.map((value) => value.toJson()).toList(),
      "mood": mood,
      "avatar_timeline": timeline,
    };

}
