import 'dart:convert';

class Intrest {
  Intrest({
    this.id,
    this.name,
    this.amount,
    this.questions,
  });

  int id;
  String name;
  int amount;
  List<dynamic> questions;

  factory Intrest.fromJson(Map<String, dynamic> json) => Intrest(
    id: json["id"],
    name: json["name"],
    amount: json["amount"],
    questions: json["questions"],
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amount": amount,
        "questions": questions,
      };
}
