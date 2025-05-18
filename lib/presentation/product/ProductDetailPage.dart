import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_mart/models/product.dart';
import 'package:tech_mart/providers/cart_provider.dart';
import 'package:tech_mart/data/repositories/product_repository.dart';
import 'package:tech_mart/core/network/api_client.dart';
import 'package:intl/intl.dart';
import 'package:tech_mart/presentation/cart/CartPage.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ProductRepository _productRepository = ProductRepository(ApiClient());
  Product? _product;
  bool _isLoading = true;
  final List<String> colors = ['Đen', 'Trắng', 'Xanh', 'Hồng'];
  final List<String> storages = ['128GB', '256GB', '512GB'];
  String selectedColor = 'Đen';
  String selectedStorage = '128GB';
  int _quantity = 1;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    try {
      final product = await _productRepository.getProductDetails(widget.productId);
      setState(() {
        _product = product;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // TODO: Handle error
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMediumScreen = size.width >= 600 && size.width < 1200;
    final isLargeScreen = size.width >= 1200;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết sản phẩm'),
        ),
        body: const Center(
          child: Text('Không tìm thấy sản phẩm'),
        ),
      );
    }

    final product = _product!;

    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: isSmallScreen ? 20 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: isSmallScreen ? 20 : 24,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: isSmallScreen ? 20 : 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                AspectRatio(
                  aspectRatio: isSmallScreen ? 1 : 1.2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(isSmallScreen ? 24 : 32),
                        bottomRight: Radius.circular(isSmallScreen ? 24 : 32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: isSmallScreen ? 12 : 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(isSmallScreen ? 24 : 32),
                        bottomRight: Radius.circular(isSmallScreen ? 24 : 32),
                      ),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade800,
                            child: Center(
                              child: Icon(
                                Icons.photo,
                                size: isSmallScreen ? 48 : 60,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: isSmallScreen ? 8 : 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 22 : 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 8 : 10),
                        // Price Section
                        Row(
                          children: [
                            Text(
                              _formatCurrency(product.price),
                              style: TextStyle(
                                fontSize: isSmallScreen ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            if (product.discountPercentage > 0) ...[
                              SizedBox(width: isSmallScreen ? 6 : 8),
                              Text(
                                _formatCurrency(product.originalPrice),
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey.shade500,
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 6 : 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 6 : 8,
                                  vertical: isSmallScreen ? 3 : 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade900,
                                  borderRadius: BorderRadius.circular(isSmallScreen ? 4 : 6),
                                ),
                                child: Text(
                                  '-${product.discountPercent}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isSmallScreen ? 12 : 14,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 14),
                        // Rating and Reviews
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber.shade400,
                              size: isSmallScreen ? 18 : 22,
                            ),
                            SizedBox(width: isSmallScreen ? 3 : 4),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 3 : 4),
                            Text(
                              '(${product.reviews} đánh giá)',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 18),
                        // Description
                        Text(
                          'Mô tả sản phẩm',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 6 : 8),
                        Text(
                          product.description,
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            height: 1.5,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 18 : 22),
                        // Specifications
                        Text(
                          'Thông số kỹ thuật',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 6 : 8),
                        ...product.specifications.entries.map(
                          (entry) => Padding(
                            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 3 : 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: isSmallScreen ? 100 : 120,
                                  child: Text(
                                    entry.key,
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 18),
                        // Color Selection
                        Text(
                          'Chọn màu sắc',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 6 : 8),
                        Wrap(
                          spacing: isSmallScreen ? 8 : 12,
                          runSpacing: isSmallScreen ? 8 : 12,
                          children: colors.map((color) {
                            final isSelected = color == selectedColor;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColor = color;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 12 : 16,
                                  vertical: isSmallScreen ? 6 : 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.orange : Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
                                  border: Border.all(
                                    color: isSelected ? Colors.orange : Colors.grey.shade700,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  color,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.grey.shade300,
                                    fontSize: isSmallScreen ? 12 : 14,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 18),
                        // Storage Selection
                        Text(
                          'Chọn dung lượng',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 6 : 8),
                        Wrap(
                          spacing: isSmallScreen ? 8 : 12,
                          runSpacing: isSmallScreen ? 8 : 12,
                          children: storages.map((storage) {
                            final isSelected = storage == selectedStorage;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedStorage = storage;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 12 : 16,
                                  vertical: isSmallScreen ? 6 : 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.orange : Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
                                  border: Border.all(
                                    color: isSelected ? Colors.orange : Colors.grey.shade700,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  storage,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.grey.shade300,
                                    fontSize: isSmallScreen ? 12 : 14,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 18),
                        // Quantity Selection
                        Text(
                          'Số lượng',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 6 : 8),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _quantity > 1
                                  ? () {
                                      setState(() {
                                        _quantity--;
                                      });
                                    }
                                  : null,
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: _quantity > 1 ? Colors.white : Colors.grey.shade600,
                                size: isSmallScreen ? 20 : 24,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 16,
                                vertical: isSmallScreen ? 4 : 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 8),
                              ),
                              child: Text(
                                _quantity.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                                size: isSmallScreen ? 20 : 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom Action Buttons
                Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isAddingToCart
                              ? null
                              : () async {
                                  setState(() {
                                    _isAddingToCart = true;
                                  });
                                  try {
                                    final cartProvider = Provider.of<CartProvider>(context, listen: false);
                                    await cartProvider.addToCart(
                                      product.id,
                                      _quantity,
                                    );
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Đã thêm vào giỏ hàng'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isAddingToCart = false;
                                      });
                                    }
                                  }
                                },
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: isSmallScreen ? 18 : 20,
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 14 : 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 14),
                            ),
                            elevation: 4,
                            backgroundColor: Colors.orange,
                            shadowColor: Colors.orangeAccent,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                            foregroundColor: Colors.white,
                          ),
                          label: Text(_isAddingToCart ? 'Đang thêm...' : 'Thêm vào giỏ'),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement buy now functionality
                          },
                          icon: Icon(
                            Icons.flash_on,
                            color: Colors.white,
                            size: isSmallScreen ? 18 : 20,
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 14 : 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 14),
                            ),
                            elevation: 4,
                            backgroundColor: Colors.grey.shade800,
                            shadowColor: Colors.orangeAccent,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                            foregroundColor: Colors.white,
                          ),
                          label: const Text('Mua ngay'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}