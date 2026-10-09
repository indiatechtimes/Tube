class RegisteredUser {
  final String id;
  final String fullName;
  final String email;
  final String userName;
  final String avatar;
  final String coverImage;

  const RegisteredUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.userName,
    required this.avatar,
    required this.coverImage,
  });

  factory RegisteredUser.fromJson(Map<String, dynamic> json) {
    return RegisteredUser(
      id: (json['_id'] ?? json['id'] ?? "").toString(),
      fullName: (json['fullName'] ?? "").toString(),
      email: (json['email']??"").toString(),
      userName: (json['userName']??"").toString(),
      avatar: (json['avatar']?? "").toString(),
      coverImage: (json['coverImage']?? "").toString()
    );
  }
}
