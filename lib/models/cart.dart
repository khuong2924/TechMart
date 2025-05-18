import 'package:tech_mart/models/cart_item.dart';

class Cart {
  final int id;
  final int userId;
  final List<CartItem> items;
  final int totalItems;
  final double subtotal;
  final double discount;
  final double total;
  final String? discountCode;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalItems,
    required this.subtotal,
    required this.discount,
    required this.total,
    this.discountCode,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List?)?.map((item) => CartItem.fromJson(item)).toList() ?? [],
      totalItems: json['totalItems'] ?? 0,
      subtotal: (json['totalAmount'] ?? 0).toDouble(),
      discount: (json['discountAmount'] ?? 0).toDouble(),
      total: (json['finalAmount'] ?? 0).toDouble(),
      discountCode: json['appliedDiscountCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalItems': totalItems,
      'subtotal': subtotal,
      'discount': discount,
      'total': total,
      'discountCode': discountCode,
    };
  }
} 