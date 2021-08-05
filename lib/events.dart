import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:findme/globals.dart' as globals;

const String apiKey = 'e7TYHNHGsdoP8YR0Nt5CHrwg6TCkmMti';
const String eventsUrl = 'https://api.segment.io/v1/track';

void sendEvent(String event, [Map<String, dynamic> properties]) async {
  String userID = await globals.email.get();
  Map<String, dynamic> body = {
    "userId": userID,
    "event": event,
  };
  if(properties != null) body['properties'] = properties;
  await http.post(eventsUrl, body: jsonEncode(body), headers: {"Authorization": "Basic $apiKey"}).timeout(Duration(minutes: 2));
}
