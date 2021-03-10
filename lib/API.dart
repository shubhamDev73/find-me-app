import 'package:http/http.dart' as http;
import 'package:findme/globals.dart' as globals;

const String baseURL = 'https://shubham0209.pythonanywhere.com/api/';

Future<http.Response> GET(String url) async {
  String token = await globals.token.get();
  return http.get(baseURL + url, headers: {"Authorization": "Bearer $token"});
}

Future<T> GETResponse<T>(String url, {T Function(String) decoder, Function callback}) async {

  final response = await GET(url);
  if (response.statusCode == 200) {
    T result = decoder?.call(response.body) ?? response.body;
    callback?.call(result);
    return result;
  } else {
    throw Exception('Failed to load: ${response.statusCode}');
  }

}

Future<http.Response> POST(String url, String body, {bool useToken = true}) async {
  String token = await globals.token.get();
  return http.post(baseURL + url, body: body, headers: useToken ? {"Authorization": "Bearer $token"} : {});
}
