import 'package:flutter/material.dart';
import 'package:tech_mart/models/product.dart' hide ProductSpecification;
import 'package:tech_mart/models/product_specification.dart';
import 'package:tech_mart/presentation/product/ProductDetailPage.dart';
import 'package:intl/intl.dart';
import 'package:tech_mart/data/repositories/product_repository.dart';
import 'package:tech_mart/core/network/api_client.dart';
import 'package:tech_mart/presentation/home/components/product_card.dart';

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
  final ProductRepository _productRepository = ProductRepository(ApiClient());
  List<Product> _products = [];
  List<String> _brands = [];
  bool _isLoading = true;
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  static const int _pageSize = 10;

  // Search and filter controllers
  final TextEditingController _searchController = TextEditingController();
  RangeValues _priceRange = const RangeValues(0, 100000000);
  String? _selectedBrand;
  bool _showOnlyDiscounted = false;
  bool _isFilterVisible = false;
  String _sortBy = 'price';
  String _sortDirection = 'asc';

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    try {
      final brands = await _productRepository.getBrandsByCategory(_getCategoryId(widget.categoryName));
      setState(() {
        _brands = brands;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _productRepository.getProductsByCategory(
        categoryId: _getCategoryId(widget.categoryName),
        page: _currentPage,
        size: _pageSize,
      );
      
      final List<dynamic> productsJson = response['content'];
      final products = productsJson.map((json) => Product.fromJson(json)).toList();
      
      setState(() {
        _products = products;
        _totalPages = response['totalPages'];
        _totalElements = response['totalElements'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // TODO: Handle error
    }
  }

  Future<void> _searchProducts() async {
    if (_searchController.text.isEmpty) {
      _loadProducts();
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _productRepository.searchProducts(
        keyword: _searchController.text,
        page: _currentPage,
        size: _pageSize,
      );
      
      final List<dynamic> productsJson = response['content'];
      final products = productsJson.map((json) => Product.fromJson(json)).toList();
      
      setState(() {
        _products = products;
        _totalPages = response['totalPages'];
        _totalElements = response['totalElements'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // TODO: Handle error
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    if (_searchController.text.isNotEmpty) {
      _searchProducts();
    } else {
      _loadProducts();
    }
  }

  void _applyFilters() {
    setState(() {
      _currentPage = 0;
      _isFilterVisible = false;
    });
    _loadProducts();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _priceRange = const RangeValues(0, 100000000);
      _selectedBrand = null;
      _showOnlyDiscounted = false;
      _sortBy = 'price';
      _sortDirection = 'asc';
      _currentPage = 0;
      _isFilterVisible = false;
    });
    _loadProducts();
  }

  int _getCategoryId(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'điện thoại':
        return 2;
      case 'laptop':
        return 3;
      case 'tai nghe':
        return 4;
      case 'đồng hồ':
        return 5;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            icon: Icon(
              _isFilterVisible ? Icons.close : Icons.filter_list,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isFilterVisible = !_isFilterVisible;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchProducts();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onSubmitted: (_) => _searchProducts(),
            ),
          ),
          // Filter Panel
          if (_isFilterVisible)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bộ lọc',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _resetFilters,
                        icon: const Icon(Icons.refresh, color: Colors.orange),
                        label: const Text(
                          'Đặt lại',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Price Range
                  const Text(
                    'Khoảng giá',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 100000000,
                    divisions: 100,
                    activeColor: Colors.orange,
                    inactiveColor: Colors.grey.shade300,
                    labels: RangeLabels(
                      NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0)
                          .format(_priceRange.start),
                      NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0)
                          .format(_priceRange.end),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  // Sort Options
                  const SizedBox(height: 16),
                  const Text(
                    'Sắp xếp theo',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _sortBy,
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'price', child: Text('Giá')),
                            DropdownMenuItem(value: 'name', child: Text('Tên')),
                            DropdownMenuItem(value: 'createdAt', child: Text('Mới nhất')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _sortBy = value;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _sortDirection == 'asc' ? Icons.arrow_upward : Icons.arrow_downward,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            setState(() {
                              _sortDirection = _sortDirection == 'asc' ? 'desc' : 'asc';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  // Brand Filter
                  if (_brands.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Thương hiệu',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _brands.map((brand) {
                        return FilterChip(
                          label: Text(brand),
                          selected: _selectedBrand == brand,
                          selectedColor: Colors.orange.withOpacity(0.2),
                          checkmarkColor: Colors.orange,
                          labelStyle: TextStyle(
                            color: _selectedBrand == brand ? Colors.orange : Colors.black87,
                          ),
                          backgroundColor: Colors.grey.shade50,
                          onSelected: (selected) {
                            setState(() {
                              _selectedBrand = selected ? brand : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                  // Discount Filter
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text(
                      'Chỉ hiện sản phẩm giảm giá',
                      style: TextStyle(color: Colors.black87),
                    ),
                    value: _showOnlyDiscounted,
                    activeColor: Colors.orange,
                    onChanged: (value) {
                      setState(() {
                        _showOnlyDiscounted = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Áp dụng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Product Grid
          Expanded(
            child: _isLoading && _products.isEmpty
                ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                : _products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Không tìm thấy sản phẩm',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return GestureDetector(
                            onTap: () => _navigateToProductDetail(product),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                      child: Image.network(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: Colors.grey.shade100,
                                          child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0)
                                              .format(product.price),
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        if (product.discountPercentage > 0)
                                          Container(
                                            margin: const EdgeInsets.only(top: 4),
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '-${product.discountPercentage.toInt()}%',
                                              style: const TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
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
          ),
          // Pagination
          if (_totalPages > 1)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.black87),
                    onPressed: _currentPage > 0 ? () => _onPageChanged(_currentPage - 1) : null,
                  ),
                  ...List.generate(_totalPages, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () => _onPageChanged(index),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? Colors.orange : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: _currentPage == index ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.black87),
                    onPressed: _currentPage < _totalPages - 1 ? () => _onPageChanged(_currentPage + 1) : null,
                  ),
                ],
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
          productId: product.id,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}