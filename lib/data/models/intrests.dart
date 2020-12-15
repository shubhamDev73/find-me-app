// To parse this JSON data, do
//
//     final intrest = intrestFromJson(jsonString);

import 'dart:convert';

Intrest intrestFromJson(String str) => Intrest.fromJson(json.decode(str));

String intrestToJson(Intrest data) => json.encode(data.toJson());

class Intrest {
  Intrest({
    this.title,
    this.intensity,
  });

  String title;
  double intensity;

  factory Intrest.fromJson(Map<String, dynamic> json) => Intrest(
        title: json["title"],
        intensity: json["intensity"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "intensity": intensity,
      };
}
