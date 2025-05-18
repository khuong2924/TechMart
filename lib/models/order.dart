import 'package:tech_mart/models/cart_item.dart';
import 'package:intl/intl.dart';

class Order {
  final int id;
  final String orderNumber;
  final DateTime orderDate;
  final double finalAmount;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final int itemCount;
  final String orderSummary;
  final String? estimatedDeliveryDate;
  final String? confirmationMessage;
  final String? paymentUrl;
  final String? transactionId;

  Order({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.finalAmount,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.itemCount,
    required this.orderSummary,
    this.estimatedDeliveryDate,
    this.confirmationMessage,
    this.paymentUrl,
    this.transactionId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['orderId'] ?? json['id'],
      orderNumber: json['orderNumber'] ?? '',
      orderDate: json['orderDate'] != null 
          ? DateTime.parse(json['orderDate']) 
          : DateTime.now(),
      finalAmount: (json['totalAmount'] ?? json['finalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'PENDING',
      paymentMethod: json['paymentMethod'] ?? 'CASH',
      paymentStatus: json['paymentStatus'] ?? 'PENDING',
      itemCount: json['itemCount'] ?? 0,
      orderSummary: json['orderSummary'] ?? '',
      estimatedDeliveryDate: json['estimatedDeliveryDate'],
      confirmationMessage: json['confirmationMessage'],
      paymentUrl: json['paymentUrl'],
      transactionId: json['transactionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': id,
      'orderNumber': orderNumber,
      'orderDate': orderDate.toIso8601String(),
      'totalAmount': finalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'itemCount': itemCount,
      'orderSummary': orderSummary,
      'estimatedDeliveryDate': estimatedDeliveryDate,
      'confirmationMessage': confirmationMessage,
      'paymentUrl': paymentUrl,
      'transactionId': transactionId,
    };
  }
} 