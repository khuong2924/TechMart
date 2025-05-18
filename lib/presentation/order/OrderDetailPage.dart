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

  Widget _buildInfoRow(String label, String value, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.grey.shade400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          ...children,
        ],
      ),
    );
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
              _buildSection(
                'Order Status',
                [
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
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 20 : 24),

              // Order Items
              _buildSection(
                'Order Items',
                [
                  Text(
                    order.orderSummary,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  _buildInfoRow('Total Items', '${order.itemCount} items', isSmallScreen),
                ],
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 20 : 24),

              // Payment Details
              _buildSection(
                'Payment Details',
                [
                  _buildInfoRow('Payment Method', order.paymentMethod, isSmallScreen),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  _buildInfoRow('Total Amount', _formatCurrency(order.finalAmount), isSmallScreen),
                ],
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 20 : 24),

              // Order Information
              _buildSection(
                'Order Information',
                [
                  _buildInfoRow(
                    'Order Date',
                    DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate),
                    isSmallScreen,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  _buildInfoRow('Order ID', '#${order.id}', isSmallScreen),
                ],
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 20 : 24),

              // Delivery Information
              _buildSection(
                'Delivery Information',
                [
                  _buildInfoRow('Shipping Address', '123 Main Street, City', isSmallScreen),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  _buildInfoRow('Recipient Name', 'John Doe', isSmallScreen),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  _buildInfoRow('Phone Number', '+84 123 456 789', isSmallScreen),
                ],
                isSmallScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 