import 'package:findme/models/interests.dart';

class User {
  String nick;
  Map<String, dynamic> avatar;
  Map<String, dynamic> personality;
  Map<int, Interest> interests;
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
    interests: Map.fromIterable(json["interests"], key: (interest) => interest['id'], value: (interest) => Interest.fromJson(interest)),
    mood: json["mood"],
  );

  Map<String, dynamic> toJson() =>
    {
      "nick": nick,
      "avatar": avatar,
      "personality": personality,
      "interests": interests.entries.map((entry) => entry.value.toJson()).toList(),
      "mood": mood,
    };

}
