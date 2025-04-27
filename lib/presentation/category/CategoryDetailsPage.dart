import 'package:flutter/material.dart';
import 'package:tech_mart/presentation/product/ProductDetailPage.dart';
import 'package:intl/intl.dart';

class Product {
  final String id;
  final String name;
  final String image;
  final int price; // Giá bằng VND
  final double rating;
  final int reviews;
  final bool isAvailable;
  final List<String> colors;
  final Map<String, String> specifications;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.isAvailable,
    required this.colors,
    required this.specifications,
  });
}

class CategoryDetailsPage extends StatefulWidget {
  final String categoryName;

  const CategoryDetailsPage({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  String _selectedFilter = 'Phổ biến';
  bool _isGridView = true;

  // Dữ liệu mẫu - sản phẩm theo danh mục
  final Map<String, List<Product>> _productsByCategory = {
    'Điện thoại': [
      Product(
        id: 's1',
        name: 'iPhone 15 Pro',
        image: 'assets/images/iphone15pro.jpg',
        price: 29970000, // Chuyển đổi từ INR sang VND (xấp xỉ)
        rating: 4.8,
        reviews: 324,
        isAvailable: true,
        colors: ['Đen Titan', 'Bạc', 'Titan Tự nhiên', 'Titan Xanh'],
        specifications: {
          "Màn hình": "6.1 inch, OLED, Super Retina XDR",
          "Chip": "A17 Pro",
          "RAM": "8 GB",
          "Bộ nhớ trong": "128 GB",
          "Camera sau": "48MP + 12MP + 12MP",
          "Camera trước": "12MP",
          "Pin": "3274 mAh"
        },
      ),
      Product(
        id: 's2',
        name: 'Samsung Galaxy S24 Ultra',
        image: 'assets/images/s24ultra.jpg',
        price: 32500000,
        rating: 4.7,
        reviews: 289,
        isAvailable: true,
        colors: ['Đen Titan', 'Xám Titan', 'Tím Titan'],
        specifications: {
          "Màn hình": "6.8 inch, Dynamic AMOLED 2X",
          "Chip": "Snapdragon 8 Gen 3",
          "RAM": "12 GB",
          "Bộ nhớ trong": "256 GB",
          "Camera sau": "200MP + 12MP + 50MP + 10MP",
          "Camera trước": "12MP",
          "Pin": "5000 mAh"
        },
      ),
      Product(
        id: 's3',
        name: 'Google Pixel 8 Pro',
        image: 'assets/images/pixel8pro.jpg',
        price: 25000000,
        rating: 4.6,
        reviews: 178,
        isAvailable: true,
        colors: ['Đen Obsidian', 'Trắng Sứ', 'Xanh Bay'],
        specifications: {
          "Màn hình": "6.7 inch, LTPO OLED",
          "Chip": "Google Tensor G3",
          "RAM": "12 GB",
          "Bộ nhớ trong": "128 GB",
          "Camera sau": "50MP + 48MP + 48MP",
          "Camera trước": "10.5MP",
          "Pin": "5050 mAh"
        },
      ),
      Product(
        id: 's4',
        name: 'OnePlus 12',
        image: 'assets/images/oneplus12.jpg',
        price: 16250000,
        rating: 4.5,
        reviews: 256,
        isAvailable: true,
        colors: ['Đen Lụa', 'Xanh Bất Tận'],
        specifications: {
          "Màn hình": "6.82 inch, LTPO AMOLED",
          "Chip": "Snapdragon 8 Gen 3",
          "RAM": "12 GB",
          "Bộ nhớ trong": "256 GB",
          "Camera sau": "50MP + 48MP + 64MP",
          "Camera trước": "32MP",
          "Pin": "5400 mAh"
        },
      ),
    ],
    'Laptop': [
      Product(
        id: 'l1',
        name: 'MacBook Pro 16"',
        image: 'assets/images/macbook16.jpg',
        price: 62500000,
        rating: 4.9,
        reviews: 167,
        isAvailable: true,
        colors: ['Xám Không Gian', 'Bạc'],
        specifications: {
          "Bộ xử lý": "Apple M3 Pro",
          "RAM": "32 GB",
          "Ổ cứng": "1 TB SSD",
          "Màn hình": "16 inch, Liquid Retina XDR",
          "Đồ họa": "M3 Pro 19-core GPU",
          "Hệ điều hành": "macOS Sonoma"
        },
      ),
      Product(
        id: 'l2',
        name: 'Dell XPS 15',
        image: 'assets/images/xps15.jpg',
        price: 45000000,
        rating: 4.7,
        reviews: 142,
        isAvailable: true,
        colors: ['Bạc Platinum'],
        specifications: {
          "Bộ xử lý": "Intel Core i9-13900H",
          "RAM": "32 GB",
          "Ổ cứng": "1 TB SSD",
          "Màn hình": "15.6 inch, OLED 3.5K",
          "Đồ họa": "NVIDIA GeForce RTX 4070",
          "Hệ điều hành": "Windows 11 Pro"
        },
      ),
      Product(
        id: 'l3',
        name: 'Lenovo ThinkPad X1 Carbon',
        image: 'assets/images/thinkpadx1.jpg',
        price: 40000000,
        rating: 4.6,
        reviews: 98,
        isAvailable: false,
        colors: ['Đen'],
        specifications: {
          "Bộ xử lý": "Intel Core i7-1365U",
          "RAM": "16 GB",
          "Ổ cứng": "512 GB SSD",
          "Màn hình": "14 inch, WUXGA IPS",
          "Đồ họa": "Intel Iris Xe Graphics",
          "Hệ điều hành": "Windows 11 Pro"
        },
      ),
    ],
    'Tai nghe': [
      Product(
        id: 'h1',
        name: 'Sony WH-1000XM5',
        image: 'assets/images/sonywh1000xm5.jpg',
        price: 8750000,
        rating: 4.8,
        reviews: 213,
        isAvailable: true,
        colors: ['Đen', 'Bạc'],
        specifications: {
          "Loại": "Over-ear",
          "Kết nối": "Bluetooth 5.2",
          "Thời lượng pin": "30 giờ",
          "Chống ồn": "Adaptive Noise Cancellation",
          "Microphone": "8 microphones with AI noise reduction",
          "Trọng lượng": "250g"
        },
      ),
      Product(
        id: 'h2',
        name: 'Apple AirPods Pro 2',
        image: 'assets/images/airpodspro2.jpg',
        price: 6225000,
        rating: 4.7,
        reviews: 345,
        isAvailable: true,
        colors: ['Trắng'],
        specifications: {
          "Loại": "In-ear",
          "Kết nối": "Bluetooth 5.3",
          "Thời lượng pin": "6 giờ (30 giờ với case)",
          "Chống ồn": "Active Noise Cancellation",
          "Chống nước": "IP54",
          "Trọng lượng": "5.3g (mỗi tai nghe)"
        },
      ),
      Product(
        id: 'h3',
        name: 'Bose QuietComfort Ultra',
        image: 'assets/images/boseqcultra.jpg',
        price: 8225000,
        rating: 4.6,
        reviews: 127,
        isAvailable: true,
        colors: ['Đen', 'Trắng Khói'],
        specifications: {
          "Loại": "Over-ear",
          "Kết nối": "Bluetooth 5.1",
          "Thời lượng pin": "24 giờ",
          "Chống ồn": "CustomTune ANC",
          "Âm thanh": "Spatial Audio",
          "Trọng lượng": "240g"
        },
      ),
    ],
    'Đồng hồ thông minh': [
      Product(
        id: 'w1',
        name: 'Apple Watch Series 9',
        image: 'assets/images/applewatch9.jpg',
        price: 10475000,
        rating: 4.8,
        reviews: 189,
        isAvailable: true,
        colors: ['Đen Nửa Đêm', 'Ánh Sao', 'Bạc', 'Đỏ'],
        specifications: {
          "Kích thước": "45mm",
          "Màn hình": "LTPO OLED Always-On Retina",
          "Chip": "Apple S9",
          "Bộ nhớ": "64 GB",
          "Pin": "18 giờ",
          "Chống nước": "50m",
          "Kết nối": "Bluetooth 5.3, Wi-Fi, LTE (tùy chọn)"
        },
      ),
      Product(
        id: 'w2',
        name: 'Samsung Galaxy Watch 6',
        image: 'assets/images/galaxywatch6.jpg',
        price: 8500000,
        rating: 4.6,
        reviews: 142,
        isAvailable: true,
        colors: ['Đen Graphite', 'Bạc'],
        specifications: {
          "Kích thước": "44mm",
          "Màn hình": "Super AMOLED",
          "Chip": "Exynos W930",
          "RAM": "2 GB",
          "Bộ nhớ": "16 GB",
          "Pin": "425 mAh (40 giờ)",
          "Chống nước": "IP68, 5ATM"
        },
      ),
      Product(
        id: 'w3',
        name: 'Garmin Venu 3',
        image: 'assets/images/garminvenu3.jpg',
        price: 12000000,
        rating: 4.7,
        reviews: 89,
        isAvailable: true,
        colors: ['Đen', 'Bạc', 'Xám Đá'],
        specifications: {
          "Kích thước": "45mm",
          "Màn hình": "AMOLED",
          "Pin": "14 ngày (chế độ thông minh)",
          "Bộ nhớ": "8 GB",
          "GPS": "Multi-GNSS",
          "Tính năng sức khỏe": "Theo dõi nhịp tim, SpO2, giấc ngủ, stress",
          "Chống nước": "5ATM"
        },
      ),
    ],
  };

  List<Product> get _currentProducts {
    if (_productsByCategory.containsKey(widget.categoryName)) {
      return _productsByCategory[widget.categoryName]!;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view, color: Colors.black),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tìm thấy ${_currentProducts.length} sản phẩm',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Phổ biến', Icons.trending_up),
                      _buildFilterChip('Mới nhất', Icons.new_releases),
                      _buildFilterChip('Giá: Thấp đến cao', Icons.arrow_upward),
                      _buildFilterChip('Giá: Cao đến thấp', Icons.arrow_downward),
                      _buildFilterChip('Đánh giá', Icons.star),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Products section
          Expanded(
            child: _currentProducts.isEmpty
                ? _buildEmptyState()
                : _isGridView ? _buildGridView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = _selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.blue : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.blue : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _currentProducts.length,
      itemBuilder: (context, index) {
        final product = _currentProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _currentProducts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final product = _currentProducts[index];
        return _buildProductListItem(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return InkWell(
      onTap: () => _navigateToProductDetail(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with "Out of Stock" overlay if needed
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: Colors.grey.shade100,
                      child: Center(
                        child: Icon(Icons.photo, size: 50, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
                if (!product.isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: const Center(
                        child: Text(
                          'HẾT HÀNG',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                      const SizedBox(width: 2),
                      Text(product.rating.toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviews})',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(product.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListItem(Product product) {
    return InkWell(
      onTap: () => _navigateToProductDetail(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Container(
                      color: Colors.grey.shade100,
                      child: Center(
                        child: Icon(Icons.photo, size: 40, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
                if (!product.isAvailable)
                  Positioned.fill(
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                      ),
                      child: const Center(
                        child: Text(
                          'HẾT HÀNG',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                        const SizedBox(width: 2),
                        Text(product.rating.toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviews})',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatCurrency(product.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (product.colors.isNotEmpty)
                      Text(
                        'Màu: ${product.colors.join(", ")}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.production_quantity_limits, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy sản phẩm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Chúng tôi không tìm thấy sản phẩm nào\ntrong danh mục này.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(amount);
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          id: product.id,
          name: product.name,
          image: product.image,
          price: product.price.toDouble(),
          rating: product.rating,
          reviews: product.reviews,
          colors: product.colors,
          specifications: product.specifications,
        ),
      ),
    );
  }
}