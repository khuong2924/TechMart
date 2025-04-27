import 'package:flutter/material.dart';
import 'package:tech_mart/models/product.dart';
import 'package:tech_mart/presentation/product/ProductDetailPage.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool showFavoriteButton;
  final bool showPromotionTags;

  const ProductCard({
    Key? key,
    required this.product,
    this.showFavoriteButton = true,
    this.showPromotionTags = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final discountPercent = product.discountPercentValue;

    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and discount badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: Colors.white,
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Icon(Icons.image, size: 50, color: Colors.grey.shade300));
                        },
                      ),
                    ),
                  ),
                ),
                if (discountPercent != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-$discountPercent%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                if (showFavoriteButton)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),

            // Product details
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
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber.shade800,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${product.rating}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviews})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.formattedPrice,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (product.originalPrice != null)
                    Row(
                      children: [
                        Text(
                          product.formattedOriginalPrice!,
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '-${product.discountPercentValue}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  if (showPromotionTags)
                    const SizedBox(height: 6),
                  if (showPromotionTags)
                    Row(
                      children: [
                        if (product.isFreeShipping)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: Text(
                              'Free Shipping',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: Colors.orange.shade100),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.card_giftcard, size: 10, color: Colors.orange.shade700),
                              const SizedBox(width: 2),
                              Text(
                                'Quà',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
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

  void _navigateToDetail(BuildContext context) {
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
          discountPrice: product.originalPrice?.toDouble(),
          discountPercent: product.discountPercent,
          isFreeShipping: product.isFreeShipping,
        ),
      ),
    );
  }
}