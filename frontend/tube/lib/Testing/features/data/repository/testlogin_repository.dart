//import 'package:http/http.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tube/Testing/features/data/models/testLoginUser.model.dart';

class TestloginRepository {
  final String testbaseUrl;
  TestloginRepository({required this.testbaseUrl});

  Future<Testloginuser> login({
    required String userName,
    required String email,
    required String password,
  }) async {
    if (testbaseUrl.trim().isEmpty) {
      throw Exception('Base url not found');
    }

    final uri = Uri.parse('testbaseUrl/api/v1/users/login');

    print(uri);

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': userName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'unable to login ${response.statusCode}:${response.body}',
      );
    }

    print('response=$response');
    print('response.body=${response.body}');
    print('response.statusCode=${response.statusCode}');

    final Map<String, dynamic> body = jsonDecode(response.body);

    final data = body['data'];
    print('data=$data');

    final userJson = data['user'] as Map<String, dynamic>;
    print('userJson=$userJson');

    final accessToken = data['accessToken'];

    print('accessToken=$accessToken');

    final refreshToken = data['refreshToken'];
    print('refreshToken=$refreshToken');

    return Testloginuser.fromJson(userJson);
  }
}
