import 'package:flutter/material.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({Key? key}) : super(key: key);

  @override
  _OrderManagementState createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  List<Map<String, dynamic>> orders = [
    {
      'id': 1001,
      'date': '2024-06-10',
      'status': 'Pending',
      'customer': 'Nguyễn Văn A',
      'total': 59990000,
      'items': [
        {'name': 'MacBook Pro 16"', 'qty': 1, 'price': 59990000},
      ],
      'address': '123 Lê Lợi, Q.1, TP.HCM',
      'phone': '0901234567',
    },
    {
      'id': 1002,
      'date': '2024-06-11',
      'status': 'Processing',
      'customer': 'Trần Thị B',
      'total': 34990000,
      'items': [
        {'name': 'iPhone 15 Pro Max', 'qty': 1, 'price': 34990000},
      ],
      'address': '456 Nguyễn Trãi, Q.5, TP.HCM',
      'phone': '0912345678',
    },
    {
      'id': 1003,
      'date': '2024-06-12',
      'status': 'Shipped',
      'customer': 'Lê Văn C',
      'total': 28990000,
      'items': [
        {'name': 'iPad Pro 12.9"', 'qty': 1, 'price': 28990000},
      ],
      'address': '789 Cách Mạng Tháng 8, Q.10, TP.HCM',
      'phone': '0923456789',
    },
    {
      'id': 1004,
      'date': '2024-06-13',
      'status': 'Delivered',
      'customer': 'Phạm Thị D',
      'total': 4990000,
      'items': [
        {'name': 'AirPods Pro 2', 'qty': 1, 'price': 4990000},
      ],
      'address': '321 Lý Thường Kiệt, Q.Tân Bình, TP.HCM',
      'phone': '0934567890',
    },
  ];

  final List<String> statuses = [
    'Pending',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  String formatCurrency(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    ) + ' ₫';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Shipped':
        return Colors.purple;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showOrderDetailDialog(Map<String, dynamic> order, int index) {
    String status = order['status'];
    bool changed = false;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: const Color(0xFF232323),
          title: Row(
            children: [
              const Icon(Icons.receipt_long, color: Colors.blue),
              const SizedBox(width: 8),
              Text('Đơn hàng #${order['id']}', style: const TextStyle(color: Colors.white)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _statusColor(status),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Khách hàng: ${order['customer']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('SĐT: ${order['phone']}', style: TextStyle(color: Colors.grey[300])),
                const SizedBox(height: 6),
                Text('Địa chỉ: ${order['address']}', style: TextStyle(color: Colors.grey[300])),
                const SizedBox(height: 12),
                const Text('Sản phẩm:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ...List.generate(order['items'].length, (i) {
                  final item = order['items'][i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(child: Text('${item['name']}', style: const TextStyle(color: Colors.white))),
                        Text('x${item['qty']}', style: TextStyle(color: Colors.grey[400])),
                        const SizedBox(width: 8),
                        Text(formatCurrency(item['price']), style: const TextStyle(color: Colors.greenAccent)),
                      ],
                    ),
                  );
                }),
                const Divider(color: Colors.white24, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng cộng:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(formatCurrency(order['total']), style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: status,
                    dropdownColor: const Color(0xFF232323),
                    decoration: const InputDecoration(
                      labelText: 'Trạng thái đơn hàng',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                    ),
                    style: const TextStyle(color: Colors.white),
                    items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setStateDialog(() {
                          status = value;
                          changed = true;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: changed
                  ? () {
                      setState(() {
                        orders[index]['status'] = status;
                      });
                      Navigator.pop(context);
                    }
                  : null,
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Order Management', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF232323),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _statusColor(order['status']),
                child: const Icon(Icons.receipt_long, color: Colors.white),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text('Đơn hàng #${order['id']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _statusColor(order['status']),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(order['status'], style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Khách: ${order['customer']}', style: TextStyle(color: Colors.grey[300], fontSize: 13)),
                  Text('Ngày: ${order['date']}', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  Text('Tổng: ${formatCurrency(order['total'])}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showOrderDetailDialog(order, index),
                tooltip: 'Sửa trạng thái',
              ),
            ),
          );
        },
      ),
    );
  }
} 