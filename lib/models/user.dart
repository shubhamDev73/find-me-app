import 'dart:collection';

import 'package:findme/models/interests.dart';

class User {
  String nick;
  String baseAvatar;
  Map<String, dynamic> avatar;
  Map<String, dynamic> personality;
  LinkedHashMap<int, Interest> interests;
  String mood;

  User({
    required this.nick,
    required this.baseAvatar,
    required this.avatar,
    required this.personality,
    required this.interests,
    required this.mood,
  });

  factory User.fromJson(Map<String, dynamic> json, bool me) {
    if(me){
      json['interests'].sort((dynamic a, dynamic b) => DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
    }else{
      json['interests'].sort((dynamic a, dynamic b) {
        int answersA = 0;
        for(dynamic question in a['questions']){
          if(question['answer'] != '') answersA++;
        }
        int answersB = 0;
        for(dynamic question in b['questions']){
          if(question['answer'] != '') answersB++;
        }
        return answersB.compareTo(answersA);
      });
    }
    return User(
      nick: json["nick"],
      baseAvatar: json["base_avatar"],
      avatar: json["avatar"],
      personality: json["personality"],
      interests: LinkedHashMap.fromIterable(json["interests"], key: (interest) => interest['id'], value: (interest) => Interest.fromJson(interest)),
      mood: json["mood"],
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
    };

}
