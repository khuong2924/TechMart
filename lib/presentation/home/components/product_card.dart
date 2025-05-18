import 'package:flutter/material.dart';
import 'package:tech_mart/models/product.dart';
import 'package:tech_mart/presentation/product/ProductDetailPage.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool showFavoriteButton;
  final bool showPromotionTags;

  const ProductCard({
    Key? key,
    required this.product,
    this.showFavoriteButton = false,
    this.showPromotionTags = true,
  }) : super(key: key);

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(productId: product.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF23272F), // dark gray background
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade900,
                          child: Center(
                            child: Icon(Icons.photo, size: 50, color: Colors.grey.shade700),
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
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: const Center(
                        child: Text(
                          'HẾT HÀNG',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 18,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        "-${product.discountPercent}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                // Favorite button
                if (showFavoriteButton)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      radius: 16,
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.white, size: 16),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          // TODO: Implement favorite functionality
                        },
                      ),
                    ),
                  ),
              ],
            ),
            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            _formatCurrency(product.price),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFFFFC107),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (product.discountPercentage > 0) ...[
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _formatCurrency(product.originalPrice),
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade500,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.star, size: 13, color: Colors.amber.shade400),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "(${product.reviews})",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 10,
                          ),
                        ),
                      ],
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
}