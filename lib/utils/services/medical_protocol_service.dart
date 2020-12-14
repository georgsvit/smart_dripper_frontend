import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_dripper_frontend/dto/Responses/medical_protocol_response.dart';
import 'package:smart_dripper_frontend/dto/routes.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/session.dart';

Future<List<MedicalProtocolResponse>> getAllMedicalProtocols() async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  final http.Response response = await http.get(
    Routes.medicalprotocols + '?culture=$locale',
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    var list = (json.decode(response.body) as List)
        .map((data) => MedicalProtocolResponse.fromJson(data))
        .toList();

    return list;
  } else {
    throw Exception(jsonDecode(response.body)['message']);
  }
}

Future<MedicalProtocolResponse> getMedicalProtocol(String id) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  var uri = Uri.encodeFull(Routes.medicalprotocols + id) + '?culture=$locale';

  final http.Response response = await http.get(
    uri,
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    print(response.body);

    var element = MedicalProtocolResponse.fromJson(json.decode(response.body));

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

Future<ApiStatus> createMedicalProtocol(MedicalProtocolResponse object) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  var uri =
      Uri.encodeFull(Routes.medicalprotocols + Routes.create) + '?culture=$locale';

  final http.Response response = await http.post(uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'Title': object.title,
        'Description': object.description,
        'MaxTemp': object.maxTemp,
        'MinTemp': object.minTemp,
        'MaxPulse': object.maxPulse,
        'MinPulse': object.minPulse,
        'MaxBloodPressure': object.maxBloodPressure,
        'MinBloodPressure': object.minBloodPressure,
        'DiseaseId': object.diseaseId,
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

Future<ApiStatus> deleteMedicalProtocol(String id) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  var uri =
      Uri.encodeFull(Routes.medicalprotocols + Routes.delete + id) + '?culture=$locale';

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

Future<ApiStatus> editMedicalProtocol(String id, MedicalProtocolResponse object) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  var uri =
      Uri.encodeFull(Routes.medicalprotocols + Routes.edit + id) + '?culture=$locale';

  final http.Response response = await http.patch(uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'Title': object.title,
        'Description': object.description,
        'MaxTemp': object.maxTemp,
        'MinTemp': object.minTemp,
        'MaxPulse': object.maxPulse,
        'MinPulse': object.minPulse,
        'MaxBloodPressure': object.maxBloodPressure,
        'MinBloodPressure': object.minBloodPressure,
        'DiseaseId': object.diseaseId,
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
