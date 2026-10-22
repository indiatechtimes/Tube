import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tube/features/auth/data/models/loginUser.model.dart';

class LoginRepository {
  final String baseUrl;
  LoginRepository({required this.baseUrl});

  // this is the function responsible for user login
  Future<LoginUser> login({
    required String userName,
    required String email,
    required String password,
  }) async {
    if (baseUrl.trim().isEmpty) {
      throw Exception('base URL is empty');
    } else {
      print('base url= $baseUrl');
    }

    final uri = Uri.parse('$baseUrl/api/v1/users/login');

    print('uri = $uri');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': userName,
        'email': email,
        'password': password,
      }),
    );
    print('response= $response');

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Request failed with status ${response.statusCode}: ${response.body}',
      );
    }

    final user = body['data'] as Map<String, dynamic>;

    print('user= $user');

  

    return LoginUser.fromJson(user);
  }
}
