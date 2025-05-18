import 'package:tech_mart/core/network/api_client.dart';
import 'package:tech_mart/models/cart.dart';
import 'package:tech_mart/models/cart_item.dart';

class CartRepository {
  final ApiClient _apiClient;

  CartRepository(this._apiClient);

  Future<Cart> getCart() async {
    final response = await _apiClient.get('/api/cart');
    return Cart.fromJson(response.data);
  }

  Future<Cart> addToCart(int productId, int quantity) async {
    final response = await _apiClient.post(
      '/api/cart/items',
      data: {
        'productId': productId,
        'quantity': quantity,
      },
    );
    return Cart.fromJson(response.data);
  }

  Future<Cart> updateCartItem(int itemId, int productId, int quantity) async {
    final response = await _apiClient.put(
      '/api/cart/items/$itemId',
      data: {
        'productId': productId,
        'quantity': quantity,
      },
    );
    return Cart.fromJson(response.data);
  }

  Future<Cart> removeCartItem(int itemId) async {
    final response = await _apiClient.delete('/api/cart/items/$itemId');
    return Cart.fromJson(response.data);
  }

  Future<Cart> clearCart() async {
    final response = await _apiClient.delete('/api/cart/clear');
    return Cart.fromJson(response.data);
  }

  Future<Cart> applyDiscount(String code) async {
    final response = await _apiClient.post(
      '/api/cart/apply-discount',
      data: {'code': code},
    );
    return Cart.fromJson(response.data);
  }

  Future<Cart> removeDiscount() async {
    final response = await _apiClient.delete('/api/cart/remove-discount');
    return Cart.fromJson(response.data);
  }
} 