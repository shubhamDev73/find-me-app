import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:findme/models/user.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/API.dart';

String token = '';
String userUrl;

User meUser, anotherUser;

Future<List<Interest>> futureInterests;
List<Interest> interests;

Future<T> returnAsFuture<T> (T data) async {
  return data;
}

void getAnotherUser (String url) {
  if(userUrl != url){
    anotherUser = null;
    userUrl = url;
  }
}

Future<User> getUser ({bool me = true, Function callback}) async {
  Future<User> futureUser;
  User user = me ? meUser : anotherUser;
  if(user == null){
    futureUser = GETResponse<User>(me ? 'me/' : userUrl,
      decoder: (Map<String, dynamic> user) => User.fromJson(user),
      callback: (User retrievedUser) {
        if(me) meUser = retrievedUser;
        else anotherUser = retrievedUser;

        if(callback != null) callback(retrievedUser);
      });
  }else{
    futureUser = returnAsFuture<User>(user);
    if(callback != null) callback(user);
  }
  return futureUser;
}

void getInterests ({Function callback}) async {
  if(interests == null){
    futureInterests = GETResponse<List<Interest>>('interests/',
      decoder: (dynamic data) => data.map<Interest>((item) => Interest.fromJson(item)).toList(),
      callback: (List<Interest> retrievedInterests) {
        interests = retrievedInterests;
        if(callback != null) callback(interests);
      }
    );
  }else{
    futureInterests = returnAsFuture<List<Interest>>(interests);
    if(callback != null) callback(interests);
  }
}

Map<String, dynamic> lastReadTimes = {};
Map<String, Function> onTimeChanges = {};

Future<File> getFile () async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/times.json');
}

Future<Map<String, dynamic>> getLastReadTimes () async {
  try {
    File file = await getFile();
    String timesString = await file.readAsString();
    lastReadTimes = jsonDecode(timesString);
  }catch(OSError) {
    lastReadTimes = {};
  }
  return lastReadTimes;
}

void setLastReadTimes ({String chatId, bool now = true}) async {
  if(now)
    lastReadTimes[chatId] = DateTime.now().millisecondsSinceEpoch;
  else
    lastReadTimes[chatId] = 0;
  File file = await getFile();
  String timesString = jsonEncode(lastReadTimes);
  await file.writeAsString(timesString);
  onTimeChanges.forEach((key, value) => value());
}
