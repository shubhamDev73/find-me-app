import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:findme/globals.dart' as globals;

const String baseURL = 'https://shubham0209.pythonanywhere.com/api/';

Future<http.Response> GET(String url) async {
  String token = await globals.token.get();
  return http.get(Uri.parse(baseURL + url), headers: {"Authorization": "Bearer $token"});
}

Future<T> GETResponse<T>(String url, {T Function(String)? decoder, Function? callback}) async {
  try{
    final response = await GET(url)
        .timeout(Duration(minutes: 2));
    if(response.statusCode == 200){
      T result = decoder?.call(response.body) ?? jsonDecode(response.body);
      callback?.call(result);
      return result;
    }else if(response.statusCode == 401 || response.statusCode == 403)
      globals.token.clear();
    else
      throw Exception('Something went wrong.');
  }catch(e){
    throw Exception('No network connection.');
  }
  throw Exception('No network connection.');

}

Future<void> POST(String url, dynamic body, {bool useToken = true, String? tempToken, Function? callback, Function(String)? onError}) async {
  String token = tempToken ?? await globals.token.get();

  try{
    final response = await http.post(Uri.parse(baseURL + url), body: jsonEncode(body), headers: useToken ? {"Authorization": "Bearer $token"} : null)
        .timeout(Duration(minutes: 2));
    if(response.statusCode == 200)
      callback?.call(jsonDecode(response.body));
    else if(response.statusCode == 401 || response.statusCode == 403)
      globals.token.clear();
    else
      onError?.call('Something went wrong.');
  }catch(e){
    onError?.call('No network connection.');
  }

}
