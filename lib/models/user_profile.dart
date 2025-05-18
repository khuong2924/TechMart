class UserProfile {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final String phone;
  final String address;
  final String gender;
  final List<String> roles;
  final bool enabled;
  final DateTime createdAt;
  final DateTime lastLogin;
  final int orderCount;
  final double totalSpent;
  final int cartItems;
  final int wishlistItems;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.gender,
    required this.roles,
    required this.enabled,
    required this.createdAt,
    required this.lastLogin,
    required this.orderCount,
    required this.totalSpent,
    required this.cartItems,
    required this.wishlistItems,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      gender: json['gender'],
      roles: List<String>.from(json['roles']),
      enabled: json['enabled'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin: DateTime.parse(json['lastLogin']),
      orderCount: json['orderCount'],
      totalSpent: json['totalSpent'].toDouble(),
      cartItems: json['cartItems'],
      wishlistItems: json['wishlistItems'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'gender': gender,
      'roles': roles,
      'enabled': enabled,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'orderCount': orderCount,
      'totalSpent': totalSpent,
      'cartItems': cartItems,
      'wishlistItems': wishlistItems,
    };
  }
} 