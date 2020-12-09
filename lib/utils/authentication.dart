import 'dart:convert';

import 'package:smart_dripper_frontend/DTO/Responses/doctor_response.dart';
import 'package:http/http.dart' as http;
import 'package:smart_dripper_frontend/DTO/routes.dart';

Future<DoctorResponse> loginDoctor(String login, String password) async {
  final http.Response response = await http.post(
    Routes.doctorsLogin,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{'Login': login, 'Password': password}),
  );
  if (response.statusCode == 200) {
    print(response.body);
    var doctor = DoctorResponse.fromJson(jsonDecode(response.body));
    print(doctor.token);
    return doctor;
  } else {
    throw Exception('Failed to login.');
  }
}

Future registerDoctor(String login, String password, String name, String surname) async {
  final http.Response response = await http.post(
    Routes.doctorsRegister,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{'Login': login, 'Password': password, 'Name': name, 'Surname': surname}),
  );
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception('Failed to login.');
  }
}
