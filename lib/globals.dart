import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:findme/models/user.dart';
import 'package:findme/models/interests.dart';
import 'package:findme/models/found.dart';
import 'package:findme/models/cachedData.dart';
import 'package:findme/API.dart';

Map<String, dynamic>? pageOnTabChange;

// token

CachedData<String> token = CachedData(
  emptyValue: '',
  cacheFile: 'token.txt',
  setCallback: (token) {
    if(token == ''){
      // clearing user data
      meUser.clear();
      otherUser.clear();
      founds.clear();

      // clearing app data specific to user
      posts.clear();

      onLogout?.call();
    } else onLogin?.call();
  },
);
Function? onLogin, onLogout;

CachedData<String> userId = CachedData(
  emptyValue: '',
  cacheFile: 'userId.txt',
);

CachedData<bool> onboarded = CachedData(
  emptyValue: true,
  cacheFile: 'onboarded.txt',
  setCallback: onOnboarded,
);
Function(bool)? onOnboarded;


// data

MappedCachedData<int, Interest> interests = MappedCachedData(
  url: 'interests/',
  cacheFile: 'interests.json',
  encoder: (data) => jsonEncode(
    LinkedHashMap<String, Map<String, dynamic>>.fromIterable(data.values,
      key: (interest) => interest.id.toString(),
      value: (interest) => interest.toJson(),
    ),
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
  setCallback: (data, [int? key]) => onInterestsChanged?.call(),
);
Function? onInterestsChanged;

MappedCachedData<String, Map<String, dynamic>> moods = MappedCachedData(
  url: 'moods/',
  cacheFile: 'moods.json',
  networkDecoder: (data) =>
  LinkedHashMap<String, Map<String, dynamic>>.fromIterable(jsonDecode(data),
    key: (mood) => mood['name'],
    value: (mood) => mood,
  ),
  setCallback: (data, [String? key]) => onMoodsChanged?.call(),
);
Function? onMoodsChanged;

MappedCachedData<String, Map<String, dynamic>> personality = MappedCachedData(
  url: 'personality/',
  cacheFile: 'personality.json',
  networkDecoder: (data) {
    Map<String, dynamic> decoded = jsonDecode(data);
    LinkedHashMap<String, Map<String, dynamic>> personality = LinkedHashMap.identity();
    personality['trait'] = Map.identity();
    for(String key in decoded['trait']!.keys){
      personality['trait']![key] = Map.identity();
      personality['trait']![key]['description'] = decoded['trait']![key]['description'];
      personality['trait']![key]['url'] = decoded['trait']![key]['url'];
      personality['trait']![key]['adjectives'] = LinkedHashMap<String, Map<String, dynamic>>.fromIterable(decoded['trait']![key]['adjectives'],
        key: (adjective) => adjective['id'].toString(),
        value: (adjective) => adjective,
      );
    }
    personality['questionnaire'] = decoded['questionnaire']!;
    return personality;
  },
  setCallback: (data, [String? key]) => onPersonalityChanged?.call(),
);
Function? onPersonalityChanged;

MappedCachedData<String, Map<String, dynamic>> avatars = MappedCachedData(
  url: 'avatars/',
  cacheFile: 'avatars.json',
  networkDecoder: (data) {
    LinkedHashMap<String, Map<String, dynamic>> avatars =
      LinkedHashMap<String, Map<String, dynamic>>.fromIterable(jsonDecode(data),
        key: (avatar) => avatar['name'],
        value: (avatar) => avatar,
      );
    for(Map<String, dynamic> avatar in avatars.values){
      avatar['avatars'] =
        LinkedHashMap<String, Map<String, dynamic>>.fromIterable(avatar['avatars'],
          key: (avatar) => avatar['mood'],
          value: (avatar) => avatar,
        );
    }
    return avatars;
  },
  setCallback: (data, [String? key]) => onAvatarsChanged?.call(),
);
Function? onAvatarsChanged;


// users

CachedData<User> meUser = CachedData(
  emptyValue: User(nick: '', baseAvatar: '', interests: LinkedHashMap.identity(), personality: {}, mood: '', avatar: {}),
  url: 'me/',
  cacheFile: 'user.json',
  encoder: (User user) => jsonEncode(user.toJson()),
  decoder: (String userString) => User.fromJson(jsonDecode(userString), true),
  setCallback: (data) => onUserChanged.forEach((key, value) => value()),
);
Map<String, Function> onUserChanged = {};

CachedData<User> otherUser = CachedData(
  emptyValue: User(nick: '', baseAvatar: '', interests: LinkedHashMap.identity(), personality: {}, mood: '', avatar: {}),
  url: '',
  encoder: (User user) => jsonEncode(user.toJson()),
  decoder: (String userString) => User.fromJson(jsonDecode(userString), false),
);

Future<User> getUser ({bool me = true}) async {
  return me ? meUser.get() : otherUser.get();
}

void setOtherUser (String url, String userId) {
  if(otherUser.url != url){
    otherUser.clear();
    otherUser.url = url;
  }
  otherUserId = userId;
}
String? otherUserId;

// found
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
  setCallback: (data, [int? key]) {
    for(int dKey in data.keys){
      if(!onFoundChanged.containsKey(dKey)) onFoundChanged[dKey] = Map.identity();
    }
    List<int> fKeys = onFoundChanged.keys.toList();
    for(int fKey in fKeys){
      if(!data.containsKey(fKey)) onFoundChanged.remove(fKey);
    }

    onChatListUpdate?.call(data);
    if(key != null && onFoundChanged.containsKey(key)) onFoundChanged[key]!.values.forEach((f) => f(data[key]));
  },
);
Function(Map<int, Found>)? onChatListUpdate;
Map<int, Map<String, void Function(Found?)>> onFoundChanged = {};

Map<String, dynamic> getMessageJSON (DocumentSnapshot message) {
  Map<String, dynamic> json = message.data() as Map<String, dynamic>;
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
  setCallback: (postsList) {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: 1000), () async {
      for(Map<String, dynamic> post in postsList){
        if(!_runningTasks.contains(post['id'])){
          POST(post['url'], post['body'],
            callback: (data) => posts.update((postsList) {
              postsList.remove(post);
              _runningTasks.remove(post['id']);
              if(!isOnline){
                isOnline = true;
                showSnackBar("Now online!");
              }
              return postsList;
            }),
            onError: (errorText) {
              if(post['first']){
                showSnackBar(errorText);
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
    });
  },
);

void addPostCall(String url, Map<String, dynamic> body, {bool Function(Map<String, dynamic>)? overwrite, bool collect = false}) {
  posts.update((postsList) {
    bool overwritten = false;
    if(overwrite != null){
      for(Map<String, dynamic> post in postsList){
        if(post['url'] == url){
          if(collect){
            for(int i = 0; i < post['body'].length; i++){
              if(overwrite(post['body'][i])){
                post['body'][i] = body;
                overwritten = true;
                break;
              }
            }
            if(!overwritten) post['body'].add(body);
            post['first'] = true;
            overwritten = true;
          }else if(overwrite(post['body'])){
            post['body'] = body;
            post['first'] = true;
            overwritten = true;
          }
          break;
        }
      }
    }
    if(!overwritten) postsList.add({"url": url, "body": collect ? [body] : body, "first": true, "id": uuid.v1()});
    return postsList;
  });
}

GlobalKey<ScaffoldMessengerState> scaffoldKey = new GlobalKey<ScaffoldMessengerState>();
void showSnackBar(String message) {
  scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(message)));
}

bool isOnline = true;
Set<String> _runningTasks = Set();
Timer? timer;

String otpUsername = '';
Map<String, dynamic> tempExternalRegister = {};
Map<String, Function> onboardingCallbacks = {};
