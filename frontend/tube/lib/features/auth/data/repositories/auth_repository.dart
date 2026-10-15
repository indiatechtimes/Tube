//import 'package:http/http.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tube/features/auth/data/models/registeredUser.model.dart';

class AuthRepository {
  final String baseUrl;

  AuthRepository({required this.baseUrl});

  Future<RegisteredUser> register({
    required String fullName,
    required String email,
    required String userName,
    required String password,
    required XFile avatar,
    XFile? coverImage,
  }) async {
    if (baseUrl.trim().isEmpty) {
      throw Exception('Base URL is empty');
    } else {
      print('BaseUrl = $baseUrl');
    }

    final uri = Uri.parse('$baseUrl/api/v1/users/register');

    print('connection url $uri');

    final Request = http.MultipartRequest('POST', uri);
    print('request=$Request');
    Request.fields['fullName'] = fullName.trim();
    Request.fields['email'] = email.trim();
    Request.fields['userName'] = userName.trim();
    Request.fields['password'] = password;

    Request.files.add(await http.MultipartFile.fromPath('avatar', avatar.path));
    if (coverImage != null) {
      Request.files.add(
        await http.MultipartFile.fromPath('coverImage', coverImage.path),
      );
    }

    // 4 > send the request ....
    final streamedResponse = await Request.send();
    print('streamedResponse= $streamedResponse');

    // 5 > read the response body....
    final response = await http.Response.fromStream(streamedResponse);
    print('response= $response');

    // JSON decode
    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    print('body= $body');

    // 6 > check whether registration successed or not ...
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Request failed with status ${response.statusCode}: ${response.body}',
      );
    }

    // 7 > convert response JSON into dart object.

    final user = body['data'] as Map<String, dynamic>;

    return RegisteredUser.fromJson(user);
  }
}

// import 'dart:convert';
// import 'dart:io';

// //import 'package:http/http.dart';
// import 'package:http/http.dart' as http;
// import 'package:tube/core/config/api_config.dart';
// import 'package:tube/features/auth/data/models/registeredUser.model.dart';

// class AuthRepository {
//   Future<RegisteredUser> register({
//     required String fullName,
//     required String email,
//     required String userName,
//     required String password,
//     required File avatar,
//     File? coverImage,
//   }) async {
//     final RegisterUri = Uri.parse('${ApiConfig.baseUrl}/api/v1/users/register');

//     final request = http.MultipartRequest('POST', RegisterUri)
//       ..fields['fullName'] = fullName
//       ..fields['email'] = email
//       ..fields['userName'] = userName
//       ..fields['password'] = password
//       ..files.add(await http.MultipartFile.fromPath('avatar', avatar.path));

//     if (coverImage != null) {
//       request.files.add(
//         await http.MultipartFile.fromPath('coverImage', coverImage.path),
//       );
//     }

//     final streamedResponse = await request.send().timeout(
//       const Duration(seconds: 30),
//     );

//     final response = await http.Response.fromStream(streamedResponse);

//     final dynamic decoded;

//     try {
//       decoded = jsonDecode(response.body);
//     } on FormatException {
//       throw Exception('server returned an invalid response');
//     }

//     if (response.statusCode != 200 && response.statusCode != 201) {
//       final message = decoded is Map ? decoded['message']?.toString() : null;

//       throw Exception(message ?? 'Registeration failed');
//     }

//     if (decoded is! Map || decoded['data'] is! Map) {
//       throw Exception('unexpacted registration response formate');
//     }

//     return RegisteredUser.fromJson(
//       Map<String,dynamic>.from(decoded['data'] as Map),
//     );
//   }
// }
