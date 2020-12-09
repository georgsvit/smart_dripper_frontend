import 'package:shared_preferences/shared_preferences.dart';

Future saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();

  prefs.setString('token', token);
}

Future<String> fetchToken() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString('token');
}