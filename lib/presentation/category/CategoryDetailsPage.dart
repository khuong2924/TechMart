import 'package:flutter/material.dart';
import 'package:tech_mart/models/product.dart' hide ProductSpecification;  // Add 'hide ProductSpecification'
import 'package:tech_mart/models/product_specification.dart';  // Add this import
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
  bool _isLoading = true;
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _productRepository.getProductsByCategory(
        _getCategoryId(widget.categoryName),
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
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading && _products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GridView.builder(
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
                                  color: Colors.black.withOpacity(0.06),
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
                                        color: Colors.grey.shade200,
                                        child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(product.price),
                                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      if (product.discountPercentage > 0)
                                        Container(
                                          margin: const EdgeInsets.only(top: 4),
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade100,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '-${product.discountPercentage.toInt()}%',
                                            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
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
                ),
                if (_totalPages > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
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
                                  color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: _currentPage == index ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
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
}