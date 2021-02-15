import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:findme/globals.dart' as globals;

const String baseURL = 'https://shubham0209.pythonanywhere.com/api/';

Future<http.Response> GET(String url) {
  return http.get(baseURL + url, headers: {"Authorization": "Bearer ${globals.token}"});
}

Future<T> GETResponse<T>(String url, {Function decoder, Function callback}) async {

  final response = await GET(url);
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    if(decoder != null) result = decoder(result);
    if(callback != null) callback(result);
    return result as T;
  } else {
    throw Exception('Failed to load: ${response.statusCode}');
  }

}

Future<http.Response> POST(String url, String body, [bool token = false]) {
  return http.post(baseURL + url, body: body, headers: token ? {"Authorization": "Bearer ${globals.token}"} : {});
}
