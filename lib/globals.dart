import 'package:findme/data/models/user.dart';
import 'package:findme/API.dart';

String token = '';

Future<User> futureUser;
User user;

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
