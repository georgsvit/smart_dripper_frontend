import 'dart:convert';
import 'dart:io';

import 'package:smart_dripper_frontend/DTO/Responses/admin_response.dart';
import 'package:smart_dripper_frontend/DTO/Responses/doctor_response.dart';
import 'package:http/http.dart' as http;
import 'package:smart_dripper_frontend/DTO/routes.dart';
import 'package:smart_dripper_frontend/models/detailed_user.dart';
import 'package:smart_dripper_frontend/utils/session.dart';

Future<DoctorResponse> loginDoctor(String login, String password) async {
  var locale = await fetchLocaleAsString();

  final http.Response response = await http.post(
    Routes.doctorsLogin + '?culture=$locale',
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{'Login': login, 'Password': password}),
  );
  if (response.statusCode == 200) {
    var doctor = DoctorResponse.fromJson(jsonDecode(response.body));
    saveToken(doctor.token);
    saveUserData(new DetailedUser(doctor.name, doctor.surname, doctor.role));
    return doctor;
  } else {
    throw Exception(jsonDecode(response.body)['message']);
  }
}

Future registerDoctor(String login, String password, String name, String surname) async {
  var locale = await fetchLocaleAsString();

  final http.Response response = await http.post(
    Routes.doctorsRegister + '?culture=$locale',
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'Login': login,
      'Password': password,
      'Name': name,
      'Surname': surname
    }),
  );
  if (response.statusCode == 200) {
    print(response);
  } else {
    throw Exception(jsonDecode(response.body)['message']);
  }
}

Future<AdminResponse> loginAdmin(String login, String password) async {
  var locale = await fetchLocaleAsString();

  final http.Response response = await http.post(
    Routes.adminsLogin + '?culture=$locale',
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{'Login': login, 'Password': password}),
  );
  if (response.statusCode == 200) {
    var admin = AdminResponse.fromJson(jsonDecode(response.body));
    saveToken(admin.token);
    saveUserData(new DetailedUser(admin.name, admin.surname, admin.role));
    return admin;
  } else {
    throw Exception(jsonDecode(response.body)['message']);
  }
}

Future registerAdmin(String login, String password, String name, String surname) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  if (token != "") {
    final http.Response response = await http.post(
      Routes.adminsRegister + '?culture=$locale',
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'Login': login,
        'Password': password,
        'Name': name,
        'Surname': surname
      }),
    );
    if (response.statusCode == 200) {
      print(response);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  } else {
    throw Exception('Token is null.');
  }
}
