class Interest {
  Interest({
    required this.id, // backend id
    required this.name,
    this.amount, // intensity of interest
    required this.questions,
    this.timestamp,
  });

  int id;
  String name;
  int? amount;
  List<dynamic> questions;
  String? timestamp;

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
    id: json["id"],
    name: json["name"],
    amount: json["amount"],
    questions: json["questions"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "amount": amount,
    "questions": questions,
    "timestamp": timestamp,
  };
}
