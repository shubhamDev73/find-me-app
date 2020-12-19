import 'package:http/http.dart' as http;
import 'package:findme/globals.dart' as globals;

import 'dart:io';

const String baseURL = 'https://shubham0209.pythonanywhere.com/api/';

Future<http.Response> GET(String url) {
  return http.get(baseURL + url, headers: {"Authorization": "Bearer ${globals.token}"});
}

Future<http.Response> POST(String url, Map<String, String> body, [bool token]) {
  return http.post(baseURL + url, body: body, headers: token ? {"Authorization": "Bearer ${globals.token}"} : {});
}
