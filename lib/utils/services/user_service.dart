import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_dripper_frontend/dto/Responses/user_response.dart';
import 'package:smart_dripper_frontend/dto/routes.dart';
import 'package:smart_dripper_frontend/utils/api_status.dart';
import 'package:smart_dripper_frontend/utils/session.dart';

Future<List<UserResponse>> getAllUsers(String role) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  print(Routes.users + role + '?culture=$locale');
  final http.Response response = await http.get(
    Routes.users + role + '?culture=$locale',
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    var list = (json.decode(response.body) as List)
        .map((data) => UserResponse.fromJson(data))
        .toList();

    return list;
  } else {
    throw Exception(jsonDecode(response.body)['message']);
  }
}

// Future<UserResponse> getUser(String id) async {
//   var locale = await fetchLocaleAsString();
//   final token = await fetchToken();

//   var uri = Uri.encodeFull(Routes.users + id) + '?culture=$locale';

//   final http.Response response = await http.get(
//     uri,
//     headers: <String, String>{
//       HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
//       HttpHeaders.authorizationHeader: 'Bearer $token'
//     },
//   );
//   if (response.statusCode == 200) {
//     print(response.body);

//     var element = UserResponse.fromJson(json.decode(response.body));

//     return element;
//   } else {
//     if (response.statusCode > 400) {
//       throw Exception("Unauthorized");
//     } else {
//       print(response.body);
//       throw Exception(jsonDecode(response.body)['errors']['id']);
//     }
//   }
// }

Future<ApiStatus> createUser(UserResponse object, String role) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  var uri =
      Uri.encodeFull(Routes.users + role + '/' + Routes.create) + '?culture=$locale';

  final http.Response response = await http.post(uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'Name': object.name,
        'Surname': object.surname,
        'Role': object.role.toUpperCase(),
        'Login': object.login,
        'Password': object.password
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

Future<ApiStatus> deleteUser(String id, String role) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  var uri =
      Uri.encodeFull(Routes.users + role + '/' + Routes.delete + id) + '?culture=$locale';

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

Future<ApiStatus> editUser(String id, UserResponse object, String role) async {
  var locale = await fetchLocaleAsString();
  final token = await fetchToken();

  var uri =
      Uri.encodeFull(Routes.users + role + '/' + Routes.edit + id) + '?culture=$locale';

  final http.Response response = await http.patch(uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'Name': object.name,
        'Surname': object.surname,
        'Role': object.role.toUpperCase()
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
