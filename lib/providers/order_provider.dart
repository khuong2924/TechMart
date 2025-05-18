import 'package:flutter/foundation.dart';
import 'package:tech_mart/data/repositories/order_repository.dart';
import 'package:tech_mart/models/order.dart';
import 'package:tech_mart/core/network/api_client.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository(ApiClient());
  List<Order> _orders = [];
  Order? _currentOrder;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  double _totalSpent = 0;

  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;
  double get totalSpent => _totalSpent;

  Future<void> loadOrders({int page = 0, int size = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _orderRepository.getOrders(page: page, size: size);
      _orders = result['orders'];
      _totalPages = result['totalPages'];
      _totalElements = result['totalElements'];
      _currentPage = result['currentPage'];
      
      // Calculate total spent
      _totalSpent = _orders.fold(0, (sum, order) => sum + order.finalAmount);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreOrders() async {
    if (_currentPage < _totalPages - 1) {
      _currentPage++;
      await loadOrders(page: _currentPage);
    }
  }

  Future<void> loadOrderDetails(int orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentOrder = await _orderRepository.getOrderDetails(orderId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Order> createOrder({
    required String shippingAddress,
    required String paymentMethod,
    String? notes,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentOrder = await _orderRepository.createOrder(
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        notes: notes,
      );
      return _currentOrder!;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterOrders({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? status,
    double? minTotal,
    double? maxTotal,
    int page = 0,
    int size = 10,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await _orderRepository.filterOrders(
        startDate: startDate,
        endDate: endDate,
        status: status,
        minTotal: minTotal,
        maxTotal: maxTotal,
        page: page,
        size: size,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 