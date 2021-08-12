import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:findme/globals.dart' as globals;

const String apiKey = 'e7TYHNHGsdoP8YR0Nt5CHrwg6TCkmMti';
const String eventsUrl = 'https://api.segment.io/v1/track';

void sendEvent(String event, [Map<String, dynamic>? properties, bool me = true]) async {
  String userId = await globals.userId.get();
  Map<String, dynamic> body = {
    "userId": userId,
    "event": event,
  };
  if(properties != null) body['properties'] = properties;
  if(!me) body['properties']['user'] = globals.otherUserId;
  String key = base64.encode(utf8.encode(apiKey + ":"));
  await http.post(Uri.parse(eventsUrl), body: jsonEncode(body), headers: {"Authorization": "Basic $key"}).timeout(Duration(minutes: 2));
}
