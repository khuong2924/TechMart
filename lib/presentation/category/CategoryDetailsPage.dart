import 'package:flutter/material.dart';
import 'package:tech_mart/presentation/product/ProductDetailPage.dart';

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final int reviews;
  final bool isAvailable;
  final List<String> colors;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.isAvailable,
    required this.colors,
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
  String _selectedFilter = 'Popular';
  bool _isGridView = true;

  // Mock data - products by category
  final Map<String, List<Product>> _productsByCategory = {
    'Smartphones': [
      Product(
        id: 's1',
        name: 'iPhone 15 Pro',
        image: 'assets/images/iphone15pro.jpg',
        price: 119900,
        rating: 4.8,
        reviews: 324,
        isAvailable: true,
        colors: ['Space Black', 'Silver', 'Natural Titanium', 'Blue Titanium'],
      ),
      Product(
        id: 's2',
        name: 'Samsung Galaxy S24 Ultra',
        image: 'assets/images/s24ultra.jpg',
        price: 129999,
        rating: 4.7,
        reviews: 289,
        isAvailable: true,
        colors: ['Titanium Black', 'Titanium Gray', 'Titanium Violet'],
      ),
      Product(
        id: 's3',
        name: 'Google Pixel 8 Pro',
        image: 'assets/images/pixel8pro.jpg',
        price: 99999,
        rating: 4.6,
        reviews: 178,
        isAvailable: true,
        colors: ['Obsidian', 'Porcelain', 'Bay'],
      ),
      Product(
        id: 's4',
        name: 'OnePlus 12',
        image: 'assets/images/oneplus12.jpg',
        price: 64999,
        rating: 4.5,
        reviews: 256,
        isAvailable: true,
        colors: ['Silky Black', 'Eternal Green'],
      ),
    ],
    'Laptops': [
      Product(
        id: 'l1',
        name: 'MacBook Pro 16"',
        image: 'assets/images/macbook16.jpg',
        price: 249900,
        rating: 4.9,
        reviews: 167,
        isAvailable: true,
        colors: ['Space Gray', 'Silver'],
      ),
      Product(
        id: 'l2',
        name: 'Dell XPS 15',
        image: 'assets/images/xps15.jpg',
        price: 179990,
        rating: 4.7,
        reviews: 142,
        isAvailable: true,
        colors: ['Platinum Silver'],
      ),
      Product(
        id: 'l3',
        name: 'Lenovo ThinkPad X1 Carbon',
        image: 'assets/images/thinkpadx1.jpg',
        price: 159990,
        rating: 4.6,
        reviews: 98,
        isAvailable: false,
        colors: ['Black'],
      ),
    ],
    'Headphones': [
      Product(
        id: 'h1',
        name: 'Sony WH-1000XM5',
        image: 'assets/images/sonywh1000xm5.jpg',
        price: 34990,
        rating: 4.8,
        reviews: 213,
        isAvailable: true,
        colors: ['Black', 'Silver'],
      ),
      Product(
        id: 'h2',
        name: 'Apple AirPods Pro 2',
        image: 'assets/images/airpodspro2.jpg',
        price: 24900,
        rating: 4.7,
        reviews: 345,
        isAvailable: true,
        colors: ['White'],
      ),
      Product(
        id: 'h3',
        name: 'Bose QuietComfort Ultra',
        image: 'assets/images/boseqcultra.jpg',
        price: 32900,
        rating: 4.6,
        reviews: 127,
        isAvailable: true,
        colors: ['Black', 'White Smoke'],
      ),
    ],
    'Smartwatches': [
      Product(
        id: 'w1',
        name: 'Apple Watch Series 9',
        image: 'assets/images/applewatch9.jpg',
        price: 41900,
        rating: 4.8,
        reviews: 189,
        isAvailable: true,
        colors: ['Midnight', 'Starlight', 'Silver', 'Product RED'],
      ),
      Product(
        id: 'w2',
        name: 'Samsung Galaxy Watch 6',
        image: 'assets/images/galaxywatch6.jpg',
        price: 33999,
        rating: 4.6,
        reviews: 142,
        isAvailable: true,
        colors: ['Graphite', 'Silver'],
      ),
      Product(
        id: 'w3',
        name: 'Garmin Venu 3',
        image: 'assets/images/garminvenu3.jpg',
        price: 47990,
        rating: 4.7,
        reviews: 89,
        isAvailable: true,
        colors: ['Black', 'Silver', 'Slate'],
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
                  'Found ${_currentProducts.length} products',
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
                      _buildFilterChip('Popular', Icons.trending_up),
                      _buildFilterChip('Newest', Icons.new_releases),
                      _buildFilterChip('Price: Low to High', Icons.arrow_upward),
                      _buildFilterChip('Price: High to Low', Icons.arrow_downward),
                      _buildFilterChip('Rating', Icons.star),
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
                          'OUT OF STOCK',
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
                    '₹${product.price.toStringAsFixed(0)}',
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
                          'OUT OF STOCK',
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
                      '₹${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (product.colors.isNotEmpty)
                      Text(
                        'Colors: ${product.colors.join(", ")}',
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
            'No products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We couldn\'t find any products\nin this category.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          id: product.id,
          name: product.name,
          image: product.image,
          price: product.price,
          rating: product.rating,
          reviews: product.reviews,
          colors: product.colors,
          specifications: {
            "Processor": "Intel Core i9 9th Gen",
            "Memory": "16 GB",
            "Storage": "1 TB SSD",
            "OS": "Mac OS Catalina",
            "Graphics": "4 GB Graphics"
          },
        ),
      ),
    );
  }
}