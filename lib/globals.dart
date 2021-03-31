import 'dart:convert';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:findme/models/user.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/models/found.dart';
import 'package:findme/models/pageTab.dart';
import 'package:findme/models/cachedData.dart';
import 'package:findme/API.dart';

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
    if(token == ''){
      currentTab.clear();
      interests.clear();
      moods.clear();
      meUser.clear();
      requests.clear();
      finds.clear();
      founds.clear();
      posts.clear();
      onLogout();
    } else onLogin();
  },
);
Function onLogin, onLogout;


// data

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
      value: (interest) => Interest.fromJson(interest),
    ),
  networkDecoder: (data) =>
    LinkedHashMap<int, Interest>.fromIterable(jsonDecode(data),
      key: (interest) => interest['id'],
      value: (interest) => Interest.fromJson(interest),
    ),
  setCallback: (data, [key]) => onInterestsChanged?.call(),
);
Function onInterestsChanged;

MappedCachedData<String, Map<String, dynamic>> moods = MappedCachedData(
  url: 'moods/',
  cacheFile: 'moods.json',
  networkDecoder: (data) =>
  LinkedHashMap<String, Map<String, dynamic>>.fromIterable(jsonDecode(data),
    key: (mood) => mood['name'],
    value: (mood) => mood,
  ),
);

MappedCachedData<String, Map<String, dynamic>> avatars = MappedCachedData(
  url: 'avatars/',
  cacheFile: 'avatars.json',
  networkDecoder: (data) =>
  LinkedHashMap<String, Map<String, dynamic>>.fromIterable(jsonDecode(data),
    key: (avatar) => avatar['name'],
    value: (avatar) => avatar,
  ),
);


// users

CachedData<User> meUser = CachedData(
  emptyValue: User(),
  url: 'me/',
  cacheFile: 'user.json',
  encoder: (User user) => jsonEncode(user.toJson()),
  decoder: (String userString) => User.fromJson(jsonDecode(userString)),
  setCallback: (data) => onUserChanged.forEach((key, value) => value()),
);
Map<String, Function> onUserChanged = {};

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
  networkDecoder: (data) {
    List<dynamic> requestList = jsonDecode(data);
    requestList.sort((dynamic a, dynamic b) => DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
    return requestList;
  },
  setCallback: (data) => onFindsUpdate?.call(),
);

CachedData<List<dynamic>> finds = CachedData(
  emptyValue: [],
  url: 'find/',
  cacheFile: 'finds.json',
  networkDecoder: (data) {
    List<dynamic> findList = jsonDecode(data)['users'];
    findList.sort((dynamic a, dynamic b) => DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
    return findList;
  },
  setCallback: (data) => onFindsUpdate?.call(),
);
Function onFindsUpdate;

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
      value: (found) => Found.fromJson(found),
    ),
  networkDecoder: (data) =>
    LinkedHashMap<int, Found>.fromIterable(jsonDecode(data),
      key: (found) => found['id'],
      value: (found) => Found.fromJson(found),
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


// POST network calls

var uuid = Uuid();

CachedData<List<dynamic>> posts = CachedData(
  emptyValue: [],
  cacheFile: 'posts.json',
  encoder: (postsList) => jsonEncode(postsList.map((post) {
    if(post.containsKey('onError')) return {'url': post['url'], 'body': post['body'], 'id': post['id']};
    return post;
  }).toList()),
  setCallback: _makePostCalls,
);

void addPostCall(String url, Map<String, dynamic> body, {bool Function(Map<String, dynamic>) overwrite}) {
  posts.update((postsList) {
    bool present = false;
    if(overwrite != null){
      for(Map<String, dynamic> post in postsList){
        if(post['url'] == url && overwrite(post['body'])){
          post['body'] = body;
          post['first'] = true;
          present = true;
          break;
        }
      }
    }
    if(!present) postsList.add({"url": url, "body": body, "first": true, "id": uuid.v1()});
    return postsList;
  });
}

GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
bool isOnline = true;
Set<String> _runningTasks = Set();
void _makePostCalls(List<dynamic> postsList) {
  for(Map<String, dynamic> post in postsList){
    if(!_runningTasks.contains(post['id'])){
      POST(post['url'], post['body'],
        callback: (data) => posts.update((postsList) {
          postsList.remove(post);
          _runningTasks.remove(post['id']);
          if(!isOnline){
            isOnline = true;
            scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Now online!")));
          }
          return postsList;
        }),
        onError: (errorText) {
          if(post['first']){
            scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(errorText)));
            post['first'] = false;
          }
          isOnline = false;
          _runningTasks.remove(post['id']);
          posts.update((data) => data);
        },
      );
      _runningTasks.add(post['id']);
    }
  }
}
