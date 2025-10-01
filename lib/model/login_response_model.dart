
class LoginResponse {
  final bool? status;
  final String message;
  final String? token;
  final UserData? userDetails;

  LoginResponse({
     this.status,
    required this.message,
    this.token,
    this.userDetails,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
      userDetails: json['user_details'] != null
          ? UserData.fromJson(json['user_details'])
          : null,
    );
  }
}

class UserData {
  final int? id;
  final String? name;
  final String? email;

  UserData({this.id, this.name, this.email});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
