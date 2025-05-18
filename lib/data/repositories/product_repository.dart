import 'package:tech_mart/core/network/api_client.dart';
import 'package:tech_mart/core/repository/base_repository.dart';
import 'package:tech_mart/core/config/api_config.dart';
import 'package:tech_mart/models/product.dart';
import 'package:tech_mart/models/review.dart';
import 'package:dio/dio.dart';

class ProductRepository extends BaseRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  Future<Map<String, dynamic>> searchProducts({
    required String keyword,
    int page = 0,
    int size = 10,
  }) async {
    return handleApiCall(() async {
      final response = await _apiClient.get(
        '/api/products/search',
        queryParameters: {
          'keyword': keyword,
          'page': page.toString(),
          'size': size.toString(),
        },
      );
      return response.data;
    });
  }

  Future<Map<String, dynamic>> getProductsByCategory({
    required int categoryId,
    int page = 0,
    int size = 10,
  }) async {
    return handleApiCall(() async {
      final response = await _apiClient.get(
        '/api/products/category/$categoryId',
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        },
      );
      return response.data;
    });
  }

  Future<List<String>> getBrandsByCategory(int categoryId) async {
    return handleApiCall(() async {
      final response = await _apiClient.get('/api/products/category/$categoryId/brands');
      return List<String>.from(response.data);
    });
  }

  Future<Product> getProductDetails(int productId) async {
    return handleApiCall(() async {
      final response = await _apiClient.get('${ApiConfig.products}/$productId');
      return Product.fromJson(response.data);
    });
  }

  Future<List<Review>> getProductReviews(int productId) async {
    final response = await _apiClient.get('/api/products/$productId/reviews');
    final data = response.data['content'] as List;
    return data.map((json) => Review.fromJson(json)).toList();
  }

  Future<Review> postProductReview({
    required int productId,
    required int rating,
    required String comment,
    required String token,
  }) async {
    final response = await _apiClient.post(
      '/api/products/$productId/reviews',
      data: {
        'rating': rating,
        'comment': comment,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return Review.fromJson(response.data);
  }
} 