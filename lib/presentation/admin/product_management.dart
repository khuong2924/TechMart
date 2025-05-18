import 'package:flutter/material.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({Key? key}) : super(key: key);

  @override
  _ProductManagementState createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': 'MacBook Pro 16"',
      'price': 59990000,
      'category': 'Laptop',
      'status': 'Còn hàng',
    },
    {
      'id': 2,
      'name': 'iPhone 15 Pro Max',
      'price': 34990000,
      'category': 'Điện thoại',
      'status': 'Còn hàng',
    },
    {
      'id': 3,
      'name': 'iPad Pro 12.9"',
      'price': 28990000,
      'category': 'Tablet',
      'status': 'Hết hàng',
    },
    {
      'id': 4,
      'name': 'Apple Watch Ultra 2',
      'price': 19990000,
      'category': 'Đồng hồ',
      'status': 'Còn hàng',
    },
    {
      'id': 5,
      'name': 'AirPods Pro 2',
      'price': 4990000,
      'category': 'Phụ kiện',
      'status': 'Còn hàng',
    },
  ];

  String searchQuery = '';
  String selectedCategory = 'Tất cả';
  String sortBy = 'Tên (A-Z)';

  final List<String> categories = [
    'Tất cả', 'Laptop', 'Điện thoại', 'Tablet', 'Đồng hồ', 'Phụ kiện'
  ];
  final List<String> sortOptions = [
    'Tên (A-Z)', 'Tên (Z-A)', 'Giá tăng dần', 'Giá giảm dần'
  ];

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Laptop': return Icons.laptop_mac;
      case 'Điện thoại': return Icons.smartphone;
      case 'Tablet': return Icons.tablet_mac;
      case 'Đồng hồ': return Icons.watch;
      case 'Phụ kiện': return Icons.headphones;
      default: return Icons.devices;
    }
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Laptop': return Colors.green;
      case 'Điện thoại': return Colors.blue;
      case 'Tablet': return Colors.orange;
      case 'Đồng hồ': return Colors.pink;
      case 'Phụ kiện': return Colors.purple;
      default: return Colors.grey;
    }
  }

  void _showProductDialog({Map<String, dynamic>? product, int? index}) {
    final isEdit = product != null;
    final nameController = TextEditingController(text: product?['name'] ?? '');
    final priceController = TextEditingController(text: product?['price']?.toString() ?? '');
    String category = product?['category'] ?? 'Laptop';
    String status = product?['status'] ?? 'Còn hàng';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232323),
        title: Text(isEdit ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm', style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
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
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Giá (VNĐ)',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                dropdownColor: const Color(0xFF232323),
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                ),
                style: const TextStyle(color: Colors.white),
                items: categories.where((c) => c != 'Tất cả').map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (value) {
                  if (value != null) category = value;
                },
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
                  DropdownMenuItem(value: 'Còn hàng', child: Text('Còn hàng')),
                  DropdownMenuItem(value: 'Hết hàng', child: Text('Hết hàng')),
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
              final newProduct = {
                'id': isEdit ? product!['id'] : products.length + 1,
                'name': nameController.text,
                'price': int.tryParse(priceController.text) ?? 0,
                'category': category,
                'status': status,
              };
              setState(() {
                if (isEdit && index != null) {
                  products[index] = newProduct;
                } else {
                  products.add(newProduct);
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

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF232323),
        title: const Text('Xóa sản phẩm', style: TextStyle(color: Colors.white)),
        content: Text('Bạn có chắc muốn xóa sản phẩm này?', style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                products.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  String formatCurrency(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    ) + ' ₫';
  }

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> filtered = products.where((p) {
      final matchesSearch = p['name'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'Tất cả' || p['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    switch (sortBy) {
      case 'Tên (A-Z)':
        filtered.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'Tên (Z-A)':
        filtered.sort((a, b) => b['name'].compareTo(a['name']));
        break;
      case 'Giá tăng dần':
        filtered.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Giá giảm dần':
        filtered.sort((a, b) => b['price'].compareTo(a['price']));
        break;
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        title: Row(
          children: [
            const Text('Product Management', style: TextStyle(color: Colors.white)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${filteredProducts.length}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showProductDialog(),
            tooltip: 'Thêm sản phẩm',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF232323),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedCategory,
                  dropdownColor: const Color(0xFF232323),
                  style: const TextStyle(color: Colors.white),
                  underline: Container(),
                  items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (value) => setState(() => selectedCategory = value!),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: sortBy,
                  dropdownColor: const Color(0xFF232323),
                  style: const TextStyle(color: Colors.white),
                  underline: Container(),
                  items: sortOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (value) => setState(() => sortBy = value!),
                ),
              ],
            ),
          ),
        ),
      ),
      body: filteredProducts.isEmpty
          ? const Center(child: Text('Không có sản phẩm nào', style: TextStyle(color: Colors.white70)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final name = product['name'] ?? '';
                final price = product['price'] ?? 0;
                final category = product['category'] ?? '';
                final status = product['status'] ?? 'Còn hàng';
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF232323),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _categoryColor(category), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: _categoryColor(category).withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _categoryColor(category),
                      child: Icon(_categoryIcon(category), color: Colors.white),
                    ),
                    title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${formatCurrency(price)} • $category • ' +
                        (status == 'Còn hàng'
                          ? '🟢 Còn hàng'
                          : '🔴 Hết hàng'),
                      style: TextStyle(color: status == 'Còn hàng' ? Colors.green[300] : Colors.red[300], fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showProductDialog(product: product, index: products.indexOf(product)),
                          tooltip: 'Cập nhật',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(products.indexOf(product)),
                          tooltip: 'Xóa',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
} 