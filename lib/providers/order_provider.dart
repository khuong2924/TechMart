import 'package:flutter/foundation.dart';
import 'package:tech_mart/data/repositories/order_repository.dart';
import 'package:tech_mart/models/order.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _orderRepository;
  List<Order> _orders = [];
  Order? _currentOrder;
  bool _isLoading = false;
  String? _error;

  OrderProvider(this._orderRepository);

  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadOrders({int page = 0, int size = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await _orderRepository.getOrders(page: page, size: size);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
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