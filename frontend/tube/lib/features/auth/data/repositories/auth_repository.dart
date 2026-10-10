import 'dart:convert';
import 'dart:io';

//import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:tube/core/config/api_config.dart';
import 'package:tube/features/auth/data/models/registeredUser.model.dart';

class AuthRepository {
  Future<RegisteredUser> register({
    required String fullName,
    required String email,
    required String userName,
    required String password,
    required File avatar,
    File? coverImage,
  }) async {
    final RegisterUri = Uri.parse('${ApiConfig.baseUrl}/api/v1/users/register');

    final request = http.MultipartRequest('POST', RegisterUri)
      ..fields['fullName'] = fullName
      ..fields['email'] = email
      ..fields['userName'] = userName
      ..fields['password'] = password
      ..files.add(await http.MultipartFile.fromPath('avatar', avatar.path));

    if (coverImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('coverImage', coverImage.path),
      );
    }

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
    );

    final response = await http.Response.fromStream(streamedResponse);

    final dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw Exception('server returned an invalid response');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      final message = decoded is Map ? decoded['message']?.toString() : null;

      throw Exception(message ?? 'Registeration failed');
    }

    if (decoded is! Map || decoded['data'] is! Map) {
      throw Exception('unexpacted registration response formate');
    }

    return RegisteredUser.fromJson(
      Map<String,dynamic>.from(decoded['data'] as Map),
    );
  }
}
