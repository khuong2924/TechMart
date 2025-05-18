import 'package:flutter/material.dart';
import 'package:tech_mart/data/repositories/order_repository.dart';
import 'package:tech_mart/models/order.dart';
import 'package:tech_mart/core/network/api_client.dart';
import 'package:tech_mart/presentation/order/OrderDetailPage.dart';
import 'package:intl/intl.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final OrderRepository _orderRepository = OrderRepository(ApiClient());
  List<Order> _orders = [];
  bool _isLoading = true;
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadOrders() async {
    try {
      final result = await _orderRepository.getOrders(page: _currentPage);
      setState(() {
        _orders = result['orders'];
        _totalPages = result['totalPages'];
        _totalElements = result['totalElements'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading orders: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (_currentPage < _totalPages - 1) {
        setState(() {
          _currentPage++;
        });
        _loadOrders();
      }
    }
  }

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

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0.5,
        title: Text(
          'My Orders',
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _orders.isEmpty
          ? Center(
              child: Text(
                'No orders found',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  color: Colors.grey.shade400,
                ),
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPage(order: order),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order #${order.id}',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 16 : 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
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
                                ],
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(order.orderDate),
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
                                      fontWeight: FontWeight.bold,
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
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
} 