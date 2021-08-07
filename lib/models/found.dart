class Found {
  int id;
  int me;
  String chatId;
  Map<String, dynamic>? lastMessage;
  int unreadNum;
  String nick;
  Map<String, dynamic> avatar;
  String mood;
  bool retainRequestSent;
  bool retained;

  Found({
    required this.id,
    required this.me,
    required this.chatId,
    required this.lastMessage,
    required this.unreadNum,
    required this.nick,
    required this.avatar,
    required this.mood,
    required this.retainRequestSent,
    required this.retained,
  });

  factory Found.fromJson(Map<String, dynamic> json) => Found(
    id: json["id"],
    me: json["me"],
    chatId: json["chat_id"],
    lastMessage: json["last_message"],
    unreadNum: json["unread_num"],
    nick: json["nick"],
    avatar: json["avatar"],
    mood: json["mood"],
    retainRequestSent: json["retain_request_sent"],
    retained: json["retained"],
  );

  Map<String, dynamic> toJson() =>
    {
      "id": id,
      "me": me,
      "chat_id": chatId,
      "last_message": lastMessage,
      "unread_num": unreadNum,
      "nick": nick,
      "avatar": avatar,
      "mood": mood,
      "retain_request_send": retainRequestSent,
      "retained": retained,
    };

}
