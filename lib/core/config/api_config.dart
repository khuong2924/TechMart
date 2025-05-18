class ApiConfig {
  static const String baseUrl = 'http://localhost:8080';
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // API Endpoints
  static const String login = '/auth/signin';
  static const String register = '/auth/register';
  static const String products = '$baseUrl/api/products';
  static const String categories = '$baseUrl/api/categories';
  static const String cart = 'api/cart';
  static const String orders = '$baseUrl/api/orders';
  static const String users = '$baseUrl/users';
  
  // Headers
  static Map<String, String> getHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
} 