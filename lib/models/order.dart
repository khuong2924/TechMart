import 'package:tech_mart/models/cart_item.dart';

class Order {
  final int id;
  final DateTime orderDate;
  final String status;
  final String shippingAddress;
  final String paymentMethod;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;
  final String? discountCode;
  final String? notes;
  final List<CartItem> items;

  Order({
    required this.id,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    this.discountCode,
    this.notes,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['orderId'] ?? json['id'] ?? 0,
      orderDate: DateTime.now(), // API không trả về orderDate, dùng tạm thời
      status: json['paymentStatus'] ?? json['status'] ?? '',
      shippingAddress: json['shippingAddress'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      subtotal: (json['totalAmount'] ?? json['subtotal'] ?? 0).toDouble(),
      shippingFee: (json['shippingFee'] ?? 0).toDouble(),
      discount: (json['discountAmount'] ?? json['discount'] ?? 0).toDouble(),
      total: (json['totalAmount'] ?? json['total'] ?? 0).toDouble(),
      discountCode: json['discountCode'] ?? json['appliedDiscountCode'],
      notes: json['notes'],
      items: (json['items'] as List?)?.map((item) => CartItem.fromJson(item)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'discount': discount,
      'total': total,
      'discountCode': discountCode,
      'notes': notes,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
} 