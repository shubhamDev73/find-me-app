class Found {
  int id;
  int me;
  String chatId;
  Map<String, dynamic> lastMessage;
  int unreadNum;
  String nick;
  Map<String, dynamic> avatar;
  bool retainRequestSent;
  bool retained;

  Found({
    this.id,
    this.me,
    this.chatId,
    this.lastMessage,
    this.unreadNum,
    this.nick,
    this.avatar,
    this.retainRequestSent,
    this.retained,
  });

  factory Found.fromJson(Map<String, dynamic> json) => Found(
    id: json["id"],
    me: json["me"],
    chatId: json["chat_id"],
    lastMessage: json["last_message"],
    unreadNum: json["unread_num"],
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
      "last_message": lastMessage,
      "unread_num": unreadNum,
      "nick": nick,
      "avatar": avatar,
      "retain_request_send": retainRequestSent,
      "retained": retained,
    };

}
