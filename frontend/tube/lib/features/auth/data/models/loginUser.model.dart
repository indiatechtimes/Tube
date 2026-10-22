//import 'package:http/http.dart';

class LoginUser {
  final String statusCode;
  final String id;
  //List<String> watchHistory = [];
  final String userName;
  final String email;
  final String fullName;
  final String avatar;
  final String coverImage;
  final String createdAt;
  final String updatedAt;
  final String accessToken;
  final String refreshToken;
  final String message;
  final String success;

  LoginUser({
    required this.statusCode,
    required this.id,
    //required this.watchHistory,
    required this.userName,
    required this.email,
    required this.fullName,
    required this.avatar,
    required this.coverImage,
    required this.createdAt,
    required this.updatedAt,
    required this.accessToken,
    required this.refreshToken,
    required this.message,
    required this.success,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      statusCode: json['statusCode']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
      //watchHistory: json['watchHistory'],
      userName: json['userName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      success: json['success']?.toString() ?? '',
    );
  }
}
