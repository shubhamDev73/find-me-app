import 'package:findme/data/models/user.dart';
import 'package:findme/data/models/interests.dart';
import 'package:findme/API.dart';

String token = '';

Future<User> futureUser;
User user;

Future<List<Interest>> futureInterests;
List<Interest> interests;

Future<T> returnAsFuture<T> (T data) async {
  return data;
}

void getUser ({Function callback}) async {
  if(user == null){
    futureUser = GETResponse<User>('me/',
        decoder: (Map<String, dynamic> user) => User.fromJson(user),
        callback: (User retrievedUser) {
          user = retrievedUser;
          if(callback != null) callback(user);
        });
  }else{
    futureUser = returnAsFuture<User>(user);
    if(callback != null) callback(user);
  }
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
