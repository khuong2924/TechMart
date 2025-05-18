import 'package:tech_mart/core/network/api_client.dart';
import 'package:tech_mart/models/user_profile.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<UserProfile> getProfile() async {
    final response = await _apiClient.get('/api/users/profile');
    return UserProfile.fromJson(response.data);
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.put('/api/users/profile', data: data);
    return UserProfile.fromJson(response.data);
  }
} 