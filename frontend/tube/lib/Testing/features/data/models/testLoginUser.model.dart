class Testloginuser {
  final String statusCode;
  final String id;
  final String userName;
  final String email;
  final String fullName;
  final String avatar;
  final String coverImage;
  final String refreshToken;
  final String accessToken;
  final String updatedAt;
  final String createdAt;
  final String message;
  final String success;

  Testloginuser({
    required this.statusCode,
    required this.id,
    required this.userName,
    required this.email,
    required this.fullName,
    required this.avatar,
    required this.coverImage,
    required this.accessToken,
    required this.refreshToken,
    required this.message,
    required this.success,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Testloginuser.fromJson(Map<String, dynamic> json) {
    return Testloginuser(
      id: json['_id']?.toString() ?? '',
      statusCode: json['statusCode']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      success: json['success']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}
