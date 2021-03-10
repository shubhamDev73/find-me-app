import 'dart:convert';

import 'package:findme/models/user.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/models/cachedData.dart';

// token

CachedData<String> token = CachedData(
  emptyValue: '',
  cacheFile: 'token.txt',
  setCallback: (token) {
    if (token == '') {
      onLogout();
      meUser.clear();
    } else onLogin();
  },
);
Function onLogin, onLogout;


// last read times

MappedCachedData<String, int> lastReadTimes = MappedCachedData(
  cacheFile: 'times.json',
  setCallback: (data, String key) => onTimesChanged[key](),
);
Map<String, Function> onTimesChanged = {};


// interests

MappedCachedData<int, Interest> interests = MappedCachedData(
  cacheFile: 'interests.json',
  url: 'interests/',
  networkDecoder: (data) =>
    Map<int, Interest>.fromIterable(data,
      key: (interest) => interest['id'],
      value: (interest) => Interest.fromJson(interest)
    ),
);


// users

CachedData<User> meUser = CachedData(
  emptyValue: User(),
  url: 'me/',
  cacheFile: 'user.json',
  encoder: (User user) => jsonEncode(user.toJson()),
  decoder: (String userString) => User.fromJson(jsonDecode(userString)),
  networkDecoder: (Map<String, dynamic> user) => User.fromJson(user),
);

CachedData<User> _anotherUser = CachedData(
  emptyValue: User(),
  url: '',
  encoder: (User user) => jsonEncode(user.toJson()),
  decoder: (String userString) => User.fromJson(jsonDecode(userString)),
  networkDecoder: (Map<String, dynamic> user) => User.fromJson(user),
);

Future<User> getUser ({bool me = true}) async {
  return me ? meUser.get() : _anotherUser.get();
}

void setAnotherUser (String url) {
  if(_anotherUser.url != url){
    _anotherUser.clear();
    _anotherUser.url = url;
  }
}
