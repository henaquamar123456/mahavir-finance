class AuthRequestModel {
  final String? mobile;
  final String? email;
  final String password;

  const AuthRequestModel({
    this.mobile,
    this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      if (mobile != null && mobile!.isNotEmpty) 'mobile': mobile,
      if (email != null && email!.isNotEmpty) 'email': email,
      'password': password,
    };
  }

  factory AuthRequestModel.fromJson(Map<String, dynamic> json) {
    return AuthRequestModel(
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String? ?? '',
    );
  }
}