class Found {
  int id;
  int me;
  String chatId;
  String nick;
  String avatar;
  bool retainRequestSent;
  bool retained;

  Found({
    this.id,
    this.me,
    this.chatId,
    this.nick,
    this.avatar,
    this.retainRequestSent,
    this.retained,
  });

  factory Found.fromJson(Map<String, dynamic> json) => Found(
    id: json["id"],
    me: json["me"],
    chatId: json["chat_id"],
    nick: json["nick"],
    avatar: json["avatar"],
    retainRequestSent: json["retain_request_sent"],
    retained: json["retained"],
  );

  Map<String, dynamic> toJson() =>
    {
      "id": id,
      "me": me,
      "chat_id": chatId,
      "nick": nick,
      "avatar": avatar,
      "retain_request_send": retainRequestSent,
      "retained": retained,
    };

}
