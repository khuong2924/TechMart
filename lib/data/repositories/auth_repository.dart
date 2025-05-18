import 'package:tech_mart/core/network/api_client.dart';
import 'package:tech_mart/core/repository/base_repository.dart';
import 'package:tech_mart/core/config/api_config.dart';
import 'package:tech_mart/models/auth/login_response.dart';

class AuthRepository extends BaseRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<LoginResponse> login(String username, String password) async {
    return handleApiCall(() async {
      final response = await _apiClient.post(
        ApiConfig.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      return LoginResponse.fromJson(response.data);
    });
  }

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
  ) async {
    return handleApiCall(() async {
      final response = await _apiClient.post(
        ApiConfig.register,
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      return response.data;
    });
  }
} 