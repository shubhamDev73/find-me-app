import 'dart:convert';

class Intrest {
  Intrest({
    this.name,
    this.amount,
  });

  String name;
  int amount;

  factory Intrest.fromJson(Map<String, dynamic> json) => Intrest(
        name: json["name"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
      };
}
