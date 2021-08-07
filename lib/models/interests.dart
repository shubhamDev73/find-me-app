class Interest {
  Interest({
    required this.id, // backend id
    required this.name,
    required this.amount, // intensity of interest
    required this.questions,
  });

  int id;
  String name;
  int amount;
  List<dynamic> questions;

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
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
