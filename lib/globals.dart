import 'dart:convert';

import 'package:findme/models/user.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/models/found.dart';
import 'package:findme/models/cachedData.dart';

// token

CachedData<String> token = CachedData(
  emptyValue: '',
  cacheFile: 'token.txt',
  setCallback: (token) {
    if (token == '') {
      meUser.clear();
      lastReadTimes.clear();
      requests.clear();
      finds.clear();
      founds.clear();
      onLogout();
    } else onLogin();
  },
);
Function onLogin, onLogout;


// last read times

MappedCachedData<String, int> lastReadTimes = MappedCachedData(
  cacheFile: 'times.json',
  setCallback: (data, [String key]) => key == null ? null : onTimesChanged.containsKey(key) ? onTimesChanged[key]() : null,
);
Map<String, Function> onTimesChanged = {};


// interests

MappedCachedData<int, Interest> interests = MappedCachedData(
  url: 'interests/',
  cacheFile: 'interests.json',
  encoder: (data) => jsonEncode(
    Map<String, Map<String, dynamic>>.fromIterable(data.values,
      key: (interest) => interest.id.toString(),
      value: (interest) => interest.toJson(),
    )
  ),
  decoder: (data) =>
    Map<int, Interest>.fromIterable(jsonDecode(data).values,
      key: (interest) => int.parse(interest['id']),
      value: (interest) => Interest.fromJson(interest)
    ),
  networkDecoder: (data) =>
    Map<int, Interest>.fromIterable(jsonDecode(data),
      key: (interest) => interest['id'],
      value: (interest) => Interest.fromJson(interest)
    ),
  setCallback: (data, [key]) => onInterestsChanged?.call(),
);
Function onInterestsChanged;

// users

CachedData<User> meUser = CachedData(
  emptyValue: User(),
  url: 'me/',
  cacheFile: 'user.json',
  encoder: (User user) => jsonEncode(user.toJson()),
  decoder: (String userString) => User.fromJson(jsonDecode(userString)),
);

CachedData<User> _anotherUser = CachedData(
  emptyValue: User(),
  url: '',
  encoder: (User user) => jsonEncode(user.toJson()),
  decoder: (String userString) => User.fromJson(jsonDecode(userString)),
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


// found

CachedData<List<dynamic>> requests = CachedData(
  emptyValue: [],
  url: 'requests/',
  cacheFile: 'requests.json',
);

CachedData<List<dynamic>> finds = CachedData(
  emptyValue: [],
  url: 'find/',
  cacheFile: 'finds.json',
  networkDecoder: (data) => jsonDecode(data)['users'],
);

CachedData<List<Found>> founds = CachedData(
  emptyValue: [],
  url: 'found/',
  cacheFile: 'founds.json',
  encoder: (data) => jsonEncode(data.map((found) => found.toJson()).toList()),
  decoder: (data) => jsonDecode(data).map<Found>((found) => Found.fromJson(found)).toList(),
);
