import 'package:tech_mart/core/network/api_client.dart';
import 'package:tech_mart/core/repository/base_repository.dart';
import 'package:tech_mart/core/config/api_config.dart';
import 'package:tech_mart/models/product.dart';

class ProductRepository extends BaseRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  Future<Map<String, dynamic>> getProductsByCategory(int categoryId, {
    int page = 0,
    int size = 10,
  }) async {
    return handleApiCall(() async {
      final response = await _apiClient.get(
        '${ApiConfig.products}/category/$categoryId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return response.data;
    });
  }

  Future<Product> getProductDetails(int productId) async {
    return handleApiCall(() async {
      final response = await _apiClient.get('${ApiConfig.products}/$productId');
      return Product.fromJson(response.data);
    });
  }
} 