import 'package:tech_mart/core/network/api_client.dart';
import 'package:tech_mart/core/repository/base_repository.dart';
import 'package:tech_mart/core/config/api_config.dart';
import 'package:tech_mart/models/category.dart';

class CategoryRepository extends BaseRepository {
  final ApiClient _apiClient;

  CategoryRepository(this._apiClient);

  Future<List<Category>> getCategories() async {
    return handleApiCall(() async {
      final response = await _apiClient.get(ApiConfig.categories);
      final List<dynamic> categoriesJson = response.data;
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    });
  }
} 