class Interest {
  Interest({
    this.id, // backend id
    this.name,
    this.amount, // intensity of interest
    this.questions,
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

Interest findInterest(List<Interest> interests, int id) {
  for (int i = 0; i < interests.length; i++) {
    if (interests[i].id == id) {
      return interests[i];
    }
  }
  return null;
}
