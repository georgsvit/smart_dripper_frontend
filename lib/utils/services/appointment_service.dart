import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_dripper_frontend/dto/Responses/appointment_response.dart';
import 'package:smart_dripper_frontend/dto/routes.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/session.dart';

Future<List<AppointmentResponse>> getAllAppointments() async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  final http.Response response = await http.get(
    Routes.appointments + '?culture=$locale',
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    var list = (json.decode(response.body) as List)
        .map((data) => AppointmentResponse.fromJson(data))
        .toList();

    return list;
  } else {
    throw Exception(jsonDecode(response.body)['message']);
  }
}

Future<AppointmentResponse> getAppointment(String id) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  var uri = Uri.encodeFull(Routes.appointments + id) + '?culture=$locale';

  final http.Response response = await http.get(
    uri,
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    print(response.body);

    var element = AppointmentResponse.fromJson(json.decode(response.body));

    return element;
  } else {
    if (response.statusCode > 400) {
      throw Exception("Unauthorized");
    } else {
      print(response.body);
      throw Exception(jsonDecode(response.body)['errors']['id']);
    }
  }
}

Future<ApiStatus> createAppointment(AppointmentResponse object) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  var uri =
      Uri.encodeFull(Routes.appointments + Routes.create) + '?culture=$locale';

  final http.Response response = await http.post(uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'MedicamentId': object.medicamentId,
        'DoctorId': object.doctorId,
        'PatientId': object.patientId
      }));
  if (response.statusCode == 200) {
    return ApiStatus.success;
  } else {
    if (response.statusCode > 400) {
      throw Exception("Unauthorized");
    } else {
      throw Exception(response.body);
    }
  }
}

Future<ApiStatus> deleteAppointment(String id) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  var uri =
      Uri.encodeFull(Routes.appointments + Routes.delete + id) + '?culture=$locale';

  final http.Response response = await http.delete(
    uri,
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    return ApiStatus.success;
  } else {
    if (response.statusCode > 400) {
      throw Exception("Unauthorized");
    } else {
      throw Exception(response.body);
    }
  }
}

Future<ApiStatus> editAppointment(String id, AppointmentResponse object) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  var uri =
      Uri.encodeFull(Routes.appointments + Routes.edit + id) + '?culture=$locale';

  final http.Response response = await http.patch(uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'MedicamentId': object.medicamentId,
        'DoctorId': object.doctorId,
        'PatientId': object.patientId
      }));
  if (response.statusCode == 200) {
    return ApiStatus.success;
  } else {
    print(response.statusCode);
    if (response.statusCode > 400) {
      throw Exception("Unauthorized");
    } else {
      throw Exception(jsonDecode(response.body)['errors']['id']);
    }
  }
}
