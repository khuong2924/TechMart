import 'package:tech_mart/core/network/api_client.dart';
import 'package:tech_mart/models/order.dart';

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository(this._apiClient);

  Future<Map<String, dynamic>> getOrders({int page = 0, int size = 10}) async {
    final response = await _apiClient.get(
      '/api/orders',
      queryParameters: {'page': page, 'size': size},
    );
    
    final List<Order> orders = (response.data['content'] as List)
        .map((json) => Order.fromJson(json))
        .toList();

    return {
      'orders': orders,
      'totalElements': response.data['totalElements'],
      'totalPages': response.data['totalPages'],
      'currentPage': response.data['page'],
    };
  }

  Future<Order> getOrderDetails(int orderId) async {
    final response = await _apiClient.get('/api/orders/$orderId');
    return Order.fromJson(response.data);
  }

  Future<Order> createOrder({
    required String shippingAddress,
    required String paymentMethod,
    String? notes,
  }) async {
    final response = await _apiClient.post(
      '/api/orders',
      data: {
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        if (notes != null) 'notes': notes,
      },
    );
    return Order.fromJson(response.data);
  }

  Future<List<Order>> filterOrders({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? status,
    double? minTotal,
    double? maxTotal,
    int page = 0,
    int size = 10,
  }) async {
    final response = await _apiClient.post(
      '/api/orders/filter',
      data: {
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        if (status != null) 'status': status,
        if (minTotal != null) 'minTotal': minTotal,
        if (maxTotal != null) 'maxTotal': maxTotal,
        'page': page,
        'size': size,
      },
    );
    return (response.data['content'] as List)
        .map((json) => Order.fromJson(json))
        .toList();
  }
} 