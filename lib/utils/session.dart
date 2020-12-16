import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_dripper_frontend/models/detailed_user.dart';

Future saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();

  prefs.setString('token', token);
}

Future saveUserData(DetailedUser user) async {
  final prefs = await SharedPreferences.getInstance();

  prefs.setString('user_id', user.id);
  prefs.setString('user_name', user.name);
  prefs.setString('user_surname', user.surname);
  prefs.setString('user_role', user.role);
}

Future<String> fetchToken() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString('token');
}

Future<DetailedUser> fetchUser() async {
  final prefs = await SharedPreferences.getInstance();

  return DetailedUser(
    prefs.getString('user_id'),
    prefs.getString('user_name'),
    prefs.getString('user_surname'),
    prefs.getString('user_role'),
  );
}

fetchLocaleAsString() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.getString('countryCode') == null) {
    return 'ua';
  }
  return prefs.getString('countryCode').toLowerCase();
}