import 'dart:convert';

import 'package:http/http.dart' as http;

class TokenPair {
  final String accessToken;
  final String refreshToken;

  const TokenPair({required this.accessToken, required this.refreshToken});
}

class AuthRepository {
  final String baseUrl;
  final http.Client client;

  AuthRepository({required this.baseUrl, http.Client? client})
    : client = client ?? http.Client();


    

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception("Invalid API response");
    }

    return decoded;
  }

  Map<String, dynamic> _getData(Map<String, dynamic> body) {
    final data = body['data'];

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid API data');
    }

    return data;
  }

  Future<TokenPair> refreshTokens(String refreshToken) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/users/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    final body = _decodeResponse(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthApiException(
        response.statusCode,
        body['message']?.toString() ?? 'Token refresh failed',
      );
    }

    final data = _getData(body);

    final accessToken = data['accessToken']?.toString() ?? '';

    final newRefreshToken = data['refreshToken']?.toString() ?? '';

    if (accessToken.isEmpty || newRefreshToken.isEmpty) {
      throw Exception('refresh response is missing tokens');
    }

    return TokenPair(accessToken: accessToken, refreshToken: newRefreshToken);
  }

  Future<Map<String, dynamic>> getCurrentUser(String accessToken) async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/users/current-user'),

      headers: {'Authorization': 'Bearer $accessToken'},
    );

    final body = _decodeResponse(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthApiException(
        response.statusCode,
        body['message']?.toString() ?? 'Unable to fetch user',
      );
    }

    return _getData(body);
  }

  Future<void> logout(String accessToken) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/v1/users/logout'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthApiException(
        response.statusCode,
        'server logout failed (${response.statusCode})',
      );
    }
  }
}

class AuthApiException implements Exception {
  final int statusCode;
  final String message;

  const AuthApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}
