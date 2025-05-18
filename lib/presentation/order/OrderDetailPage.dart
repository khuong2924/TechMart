import 'package:flutter/material.dart';
import 'package:tech_mart/models/order.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({Key? key, required this.order}) : super(key: key);

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(amount);
  }

  String _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'FFA500'; // Orange
      case 'PROCESSING':
        return '1E90FF'; // Dodger Blue
      case 'SHIPPED':
        return '4169E1'; // Royal Blue
      case 'DELIVERED':
        return '32CD32'; // Lime Green
      case 'CANCELLED':
        return 'FF0000'; // Red
      default:
        return '808080'; // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order #${order.id}',
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Status
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Status',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                            vertical: isSmallScreen ? 6 : 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(int.parse('0xFF${_getStatusColor(order.status)}')),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 12 : 16),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                            vertical: isSmallScreen ? 6 : 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(int.parse('0xFF${_getStatusColor(order.paymentStatus)}')),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.paymentStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: isSmallScreen ? 20 : 24),
              // Order Summary
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Text(
                      order.orderSummary,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),
                    Text(
                      'Items: ${order.itemCount}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isSmallScreen ? 20 : 24),
              // Payment Details
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Text(
                          order.paymentMethod,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Text(
                          _formatCurrency(order.finalAmount),
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: isSmallScreen ? 20 : 24),
              // Order Date
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Information',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Date',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate),
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 