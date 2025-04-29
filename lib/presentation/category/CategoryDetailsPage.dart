import 'package:flutter/material.dart';
import 'package:tech_mart/models/product.dart' hide ProductSpecification;  // Add 'hide ProductSpecification'
import 'package:tech_mart/models/product_specification.dart';  // Add this import
import 'package:tech_mart/presentation/product/ProductDetailPage.dart';
import 'package:intl/intl.dart';

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
        name: 'iPhone 15 Pro Max 256GB',
        image: 'assets/images/iphone15pro.jpg',
        price: 29990000,
        originalPrice: 34990000,
        discountPercent: '14%',
        rating: 4.8,
        reviews: 324,
        isAvailable: true,
        colors: ['Titan Đen', 'Titan Tự nhiên', 'Titan Xanh', 'Titan Trắng'],
        isHot: true,
        specifications: ProductSpecification.fromMap({
          "Màn hình": "6.7 inch, OLED, Super Retina XDR",
          "Chip": "A17 Pro",
          "RAM": "8 GB",
          "Bộ nhớ trong": "256 GB",
          "Camera sau": "48MP + 12MP + 12MP",
          "Camera trước": "12MP",
          "Pin": "4422 mAh, sạc nhanh 27W"
        }),
      ),
      Product(
        id: 's2',
        name: 'Samsung Galaxy S24 Ultra 256GB',
        image: 'assets/images/s24ultra.jpg',
        price: 27990000,
        originalPrice: 31990000,
        discountPercent: '12%',
        rating: 4.7,
        reviews: 289,
        isAvailable: true,
        colors: ['Đen Titan', 'Xám Titan', 'Tím Titan'],
        isHot: true,
        isNew: true,
        specifications: {
          "Màn hình": "6.8 inch, Dynamic AMOLED 2X",
          "Chip": "Snapdragon 8 Gen 3",
          "RAM": "12 GB",
          "Bộ nhớ trong": "256 GB",
          "Camera sau": "200MP + 12MP + 50MP + 10MP",
          "Camera trước": "12MP",
          "Pin": "5000 mAh, sạc nhanh 45W"
        },
      ),
    ],
    'Laptop': [
      Product(
        id: 'l1',
        name: 'MacBook Pro M3 Max 16 inch 36GB/1TB',
        image: 'assets/images/macbook16.jpg',
        price: 79990000,
        originalPrice: 84990000,
        discountPercent: '6%',
        rating: 4.9,
        reviews: 167,
        isAvailable: true,
        colors: ['Xám không gian', 'Bạc'],
        isHot: true,
        specifications: {
          "CPU": "Apple M3 Max 16-core",
          "RAM": "36 GB",
          "Ổ cứng": "1 TB SSD",
          "Màn hình": "16 inch, Liquid Retina XDR",
          "Card đồ họa": "M3 Max 40-core GPU",
          "Cổng kết nối": "3 x Thunderbolt 4, HDMI, SDXC, MagSafe 3",
          "Hệ điều hành": "macOS Sonoma"
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
      borderRadius: BorderRadius.circular(8),
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
            // Product image with badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade100,
                          child: Center(
                            child: Icon(Icons.photo, size: 50, color: Colors.grey.shade400),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Out of Stock overlay
                if (!product.isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
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

                // Discount tag
                if (product.discountPercent != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        "-${product.discountPercent}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                // Hot label
                if (product.isHot && product.isAvailable)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade600,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "HOT",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),

                // New label
                if (product.isNew && product.isAvailable)
                  Positioned(
                    top: product.isHot ? 40 : 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "MỚI",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
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

                  // Price section with original price if available
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _formatCurrency(product.price),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  if (product.originalPrice != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        _formatCurrency(product.originalPrice!),
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  const SizedBox(height: 6),

                  // Rating and shipping info
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),

                      const Spacer(),

                      if (product.isFreeShipping)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            "Free ship",
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
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
  }

  Widget _buildProductListItem(Product product) {
    return InkWell(
      onTap: () => _navigateToProductDetail(product),
      borderRadius: BorderRadius.circular(8),
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
            // Product image with badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade100,
                          child: Center(
                            child: Icon(Icons.photo, size: 40, color: Colors.grey.shade400),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Out of Stock overlay
                if (!product.isAvailable)
                  Positioned.fill(
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
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

                // Discount tag
                if (product.discountPercent != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        "-${product.discountPercent}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                // Hot label
                if (product.isHot && product.isAvailable)
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade600,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "HOT",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),

                // New label
                if (product.isNew && product.isAvailable)
                  Positioned(
                    bottom: product.isHot ? 40 : 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "MỚI",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
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

                    // Price section
                    Row(
                      children: [
                        Text(
                          _formatCurrency(product.price),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (product.originalPrice != null)
                          Text(
                            _formatCurrency(product.originalPrice!),
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Rating and free shipping
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 12, color: Colors.amber.shade700),
                              const SizedBox(width: 2),
                              Text(
                                "${product.rating}",
                                style: TextStyle(
                                  color: Colors.amber.shade900,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${product.reviews} đánh giá",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),

                        if (product.isFreeShipping) ...[
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "Miễn phí vận chuyển",
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Colors info
                    if (product.colors.isNotEmpty)
                      Text(
                        "${product.colors.length} màu",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
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
          specifications: product.specifications, // Already the right type
          discountPrice: product.originalPrice?.toDouble(),
          discountPercent: product.discountPercent,
          isFreeShipping: product.isFreeShipping,
        ),
      ),
    );
  }
}