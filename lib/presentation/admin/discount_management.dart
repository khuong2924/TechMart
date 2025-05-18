import 'package:flutter/material.dart';

class DiscountManagement extends StatefulWidget {
  const DiscountManagement({Key? key}) : super(key: key);

  @override
  _DiscountManagementState createState() => _DiscountManagementState();
}

class _DiscountManagementState extends State<DiscountManagement> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> discountCodes = [
    {
      'id': 1,
      'code': 'SUMMER10',
      'discount': 10,
      'status': 'active',
      'validUntil': '2024-07-31',
    },
    {
      'id': 2,
      'code': 'WELCOME5',
      'discount': 5,
      'status': 'scheduled',
      'validUntil': '2024-08-15',
    },
    {
      'id': 3,
      'code': 'SALE20',
      'discount': 20,
      'status': 'expired',
      'validUntil': '2024-06-01',
    },
  ];
  List<Map<String, dynamic>> productDiscounts = [
    {
      'id': 1,
      'productName': 'MacBook Pro 16"',
      'originalPrice': 59990000,
      'discountedPrice': 53991000,
      'discount': 10,
      'status': 'active',
    },
    {
      'id': 2,
      'productName': 'iPhone 15 Pro Max',
      'originalPrice': 34990000,
      'discountedPrice': 33240500,
      'discount': 5,
      'status': 'active',
    },
    {
      'id': 3,
      'productName': 'iPad Pro 12.9"',
      'originalPrice': 28990000,
      'discountedPrice': 28990000,
      'discount': 0,
      'status': 'inactive',
    },
  ];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'expired':
        return Colors.red;
      case 'scheduled':
        return Colors.orange;
      case 'inactive':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  String formatCurrency(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    ) + ' ₫';
  }

  void _showDiscountCodeDialog({Map<String, dynamic>? code, int? index}) {
    final isEdit = code != null;
    final codeController = TextEditingController(text: code?['code'] ?? '');
    final discountController = TextEditingController(text: code?['discount']?.toString() ?? '');
    String status = code?['status'] ?? 'active';
    final validUntilController = TextEditingController(text: code?['validUntil'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232323),
        title: Text(isEdit ? 'Cập nhật mã giảm giá' : 'Thêm mã giảm giá', style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Mã giảm giá',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Chiết khấu (%)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: status,
                dropdownColor: const Color(0xFF232323),
                decoration: const InputDecoration(
                  labelText: 'Trạng thái',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                ),
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Đang hoạt động')),
                  DropdownMenuItem(value: 'scheduled', child: Text('Sắp diễn ra')),
                  DropdownMenuItem(value: 'expired', child: Text('Hết hạn')),
                ],
                onChanged: (value) {
                  if (value != null) status = value;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: validUntilController,
                decoration: const InputDecoration(
                  labelText: 'Ngày hết hạn (YYYY-MM-DD)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              final newCode = {
                'id': isEdit ? code!['id'] : discountCodes.length + 1,
                'code': codeController.text,
                'discount': int.tryParse(discountController.text) ?? 0,
                'status': status,
                'validUntil': validUntilController.text,
              };
              setState(() {
                if (isEdit && index != null) {
                  discountCodes[index] = newCode;
                } else {
                  discountCodes.add(newCode);
                }
              });
              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Cập nhật' : 'Thêm'),
          ),
        ],
      ),
    );
  }

  void _showProductDiscountDialog({Map<String, dynamic>? discount, int? index}) {
    final isEdit = discount != null;
    final productNameController = TextEditingController(text: discount?['productName'] ?? '');
    final originalPriceController = TextEditingController(text: discount?['originalPrice']?.toString() ?? '');
    final discountPercentController = TextEditingController(text: discount?['discount']?.toString() ?? '');
    String status = discount?['status'] ?? 'active';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232323),
        title: Text(isEdit ? 'Cập nhật chiết khấu sản phẩm' : 'Thêm chiết khấu sản phẩm', style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên sản phẩm',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: originalPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Giá gốc (VNĐ)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: discountPercentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Chiết khấu (%)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: status,
                dropdownColor: const Color(0xFF232323),
                decoration: const InputDecoration(
                  labelText: 'Trạng thái',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                ),
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Đang hoạt động')),
                  DropdownMenuItem(value: 'inactive', child: Text('Không hoạt động')),
                ],
                onChanged: (value) {
                  if (value != null) status = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              final discountPercent = int.tryParse(discountPercentController.text) ?? 0;
              final originalPrice = int.tryParse(originalPriceController.text) ?? 0;
              final discountedPrice = (originalPrice * (100 - discountPercent) ~/ 100);
              final newDiscount = {
                'id': isEdit ? discount!['id'] : productDiscounts.length + 1,
                'productName': productNameController.text,
                'originalPrice': originalPrice,
                'discountedPrice': discountedPrice,
                'discount': discountPercent,
                'status': status,
              };
              setState(() {
                if (isEdit && index != null) {
                  productDiscounts[index] = newDiscount;
                } else {
                  productDiscounts.add(newDiscount);
                }
              });
              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Cập nhật' : 'Thêm'),
          ),
        ],
      ),
    );
  }

  void _deleteDiscountCode(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232323),
        title: const Text('Xóa mã giảm giá', style: TextStyle(color: Colors.white)),
        content: const Text('Bạn có chắc muốn xóa mã giảm giá này?', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                discountCodes.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _deleteProductDiscount(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232323),
        title: const Text('Xóa chiết khấu sản phẩm', style: TextStyle(color: Colors.white)),
        content: const Text('Bạn có chắc muốn xóa chiết khấu này?', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                productDiscounts.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Discount Management', style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(text: 'Mã giảm giá'),
            Tab(text: 'Chiết khấu sản phẩm'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Discount Codes
          ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: discountCodes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final code = discountCodes[index];
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: _getStatusColor(code['status']),
                            child: const Icon(Icons.discount, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              (code['code'] as String).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (code['discount'] > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${code['discount']}%',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                          ],
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: _getStatusColor(code['status']),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              code['status'] == 'active'
                                  ? 'Đang hoạt động'
                                  : code['status'] == 'scheduled'
                                      ? 'Sắp diễn ra'
                                      : 'Hết hạn',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('HSD: ${code['validUntil']}', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                            onPressed: () => _showDiscountCodeDialog(code: code, index: index),
                            tooltip: 'Cập nhật',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () => _deleteDiscountCode(index),
                            tooltip: 'Xóa',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Tab 2: Product Discounts
          ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: productDiscounts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final discount = productDiscounts[index];
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: _getStatusColor(discount['status']),
                            child: const Icon(Icons.local_offer, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              discount['productName'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.1,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (discount['discount'] > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${discount['discount']}%',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                          ],
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: _getStatusColor(discount['status']),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              discount['status'] == 'active' ? 'Đang hoạt động' : 'Không hoạt động',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Giá gốc: ${formatCurrency(discount['originalPrice'])}  •  Giá sau CK: ${formatCurrency(discount['discountedPrice'])}',
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                            onPressed: () => _showProductDiscountDialog(discount: discount, index: index),
                            tooltip: 'Cập nhật',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () => _deleteProductDiscount(index),
                            tooltip: 'Xóa',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            _showDiscountCodeDialog();
          } else {
            _showProductDiscountDialog();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 