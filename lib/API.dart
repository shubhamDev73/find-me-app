import 'package:http/http.dart' as http;
import 'package:findme/globals.dart' as globals;

const String baseURL = 'https://shubham0209.pythonanywhere.com/api/';

Future<http.Response> GET(String url) {
  return http.get(baseURL + url, headers: {"Authorization": "Bearer ${globals.token}"});
}

Future<http.Response> POST(String url, String body, [bool token = false]) {
  return http.post(baseURL + url, body: body, headers: token ? {"Authorization": "Bearer ${globals.token}"} : {});
}
