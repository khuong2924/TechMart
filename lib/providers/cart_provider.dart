import 'package:flutter/foundation.dart';
import 'package:tech_mart/data/repositories/cart_repository.dart';
import 'package:tech_mart/models/cart.dart';

class CartProvider with ChangeNotifier {
  final CartRepository _cartRepository;
  Cart? _cart;
  bool _isLoading = false;
  String? _error;

  CartProvider(this._cartRepository);

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _cartRepository.getCart();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(int productId, int quantity) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _cartRepository.addToCart(productId, quantity);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCartItem(int itemId, int productId, int quantity) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _cartRepository.updateCartItem(itemId, productId, quantity);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeCartItem(int itemId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _cartRepository.removeCartItem(itemId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _cartRepository.clearCart();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyDiscount(String code) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _cartRepository.applyDiscount(code);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeDiscount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cart = await _cartRepository.removeDiscount();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 