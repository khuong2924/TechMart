class LoginResponse {
  final String token;
  final String type;
  final int id;
  final String username;
  final String email;
  final List<String> roles;

  LoginResponse({
    required this.token,
    required this.type,
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      type: json['type'] as String,
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      roles: List<String>.from(json['roles'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'type': type,
      'id': id,
      'username': username,
      'email': email,
      'roles': roles,
    };
  }
} 