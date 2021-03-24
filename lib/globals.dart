import 'dart:convert';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:findme/models/user.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/models/found.dart';
import 'package:findme/models/pageTab.dart';
import 'package:findme/models/cachedData.dart';

// currentTab

CachedData<PageTab> currentTab = CachedData(
  emptyValue: PageTab.me,
  cacheFile: 'tab.txt',
  encoder: (PageTab tab) => tab.index.toString(),
  decoder: (String tabString) => PageTab.values[int.parse(tabString)],
);


// token

CachedData<String> token = CachedData(
  emptyValue: '',
  cacheFile: 'token.txt',
  setCallback: (token) {
    if (token == '') {
      currentTab.clear();
      interests.clear();
      meUser.clear();
      requests.clear();
      finds.clear();
      founds.clear();
      onLogout();
    } else onLogin();
  },
);
Function onLogin, onLogout;


// interests

MappedCachedData<int, Interest> interests = MappedCachedData(
  url: 'interests/',
  cacheFile: 'interests.json',
  encoder: (data) => jsonEncode(
    LinkedHashMap<String, Map<String, dynamic>>.fromIterable(data.values,
      key: (interest) => interest.id.toString(),
      value: (interest) => interest.toJson(),
    )
  ),
  decoder: (data) =>
    LinkedHashMap<int, Interest>.fromIterable(jsonDecode(data).values,
      key: (interest) => interest['id'],
      value: (interest) => Interest.fromJson(interest)
    ),
  networkDecoder: (data) =>
    LinkedHashMap<int, Interest>.fromIterable(jsonDecode(data),
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

MappedCachedData<int, Found> founds = MappedCachedData(
  url: 'found/',
  cacheFile: 'founds.json',
  encoder: (data) => jsonEncode(
      LinkedHashMap<String, Map<String, dynamic>>.fromIterable(data.values,
        key: (found) => found.id.toString(),
        value: (found) => found.toJson(),
      )
  ),
  decoder: (data) =>
    LinkedHashMap<int, Found>.fromIterable(jsonDecode(data).values,
      key: (found) => found['id'],
      value: (found) => Found.fromJson(found)
    ),
  networkDecoder: (data) =>
    LinkedHashMap<int, Found>.fromIterable(jsonDecode(data),
      key: (found) => found['id'],
      value: (found) => Found.fromJson(found)
    ),
  setCallback: (data, [int key]) {
    onChatListUpdate?.call(data);
    if(key != null && onFoundChanged.containsKey(key)) onFoundChanged[key](data[key]);
  },
);
Function(Map<int, Found>) onChatListUpdate;
Map<int, void Function(Found)> onFoundChanged = {};

Map<String, dynamic> getMessageJSON (DocumentSnapshot message) {
  Map<String, dynamic> json = message.data();
  json['id'] = message.id;
  json['timestamp'] = (json['timestamp']?.toDate() ?? DateTime.now()).toString();
  return json;
}
