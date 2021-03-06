import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:findme/models/user.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/API.dart';

String token = '';
String userUrl;

User meUser, anotherUser;

Future<Map<int, Interest>> futureInterests;
Map<int, Interest> interests;

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
    futureInterests = GETResponse<Map<int, Interest>>('interests/',
      decoder: (dynamic data) =>
        Map<int, Interest>.fromIterable(data,
            key: (interest) => interest['id'],
            value: (interest) => Interest.fromJson(interest)
        ),
      callback: (Map<int, Interest> retrievedInterests) {
        interests = retrievedInterests;
        if(callback != null) callback(interests);
      }
    );
  }else{
    futureInterests = returnAsFuture<Map<int, Interest>>(interests);
    if(callback != null) callback(interests);
  }
}

Map<String, dynamic> lastReadTimes = {};
Map<String, Function> onTimeChanges = {};

Future<File> getFile (String file) async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/$file');
}

Future<Map<String, dynamic>> getLastReadTimes () async {
  try {
    File file = await getFile('times.json');
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
  File file = await getFile('times.json');
  String timesString = jsonEncode(lastReadTimes);
  await file.writeAsString(timesString);
  onTimeChanges.forEach((key, value) => value());
}

Function onLogin, onLogout;

Future<String> getToken () async {
  if(token != '') return token;
  try {
    File file = await getFile('token.txt');
    token = await file.readAsString();
  }catch(OSError) {
    token = '';
  }
  return token;
}

Future<void> setToken (String newToken) async {
  token = newToken;
  if(token == '') onLogout();
  else onLogin();

  File file = await getFile('token.txt');
  await file.writeAsString(token);
}
