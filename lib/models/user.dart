import 'package:findme/models/interests.dart';

class User {
  String nick;
  String avatar;
  Map<String, dynamic> personality;
  List<Interest> interests;
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
    interests: json["interests"].map<Interest>((interest) => Interest.fromJson(interest)).toList(),
    mood: json["mood"],
  );

  Map<String, dynamic> toJson() =>
    {
      "nick": nick,
      "avatar": avatar,
      "personality": personality,
      "interests": interests.map((interest) => interest.toJson()).toList(),
      "mood": mood,
    };

}
