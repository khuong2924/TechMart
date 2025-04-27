import 'package:flutter/material.dart';
import 'package:tech_mart/models/product.dart';
import 'package:tech_mart/presentation/product/ProductDetailPage.dart';

class FlashSaleItem extends StatelessWidget {
  final Product product;
  final double soldPercent;

  const FlashSaleItem({
    Key? key,
    required this.product,
    this.soldPercent = 70,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final discountPercent = product.discountPercentValue;
    
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Discount badge and Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Icon(Icons.image, size: 40, color: Colors.grey.shade400));
                      },
                    ),
                  ),
                ),
                if (discountPercent != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        '-$discountPercent%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Product info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.formattedPrice,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (product.formattedOriginalPrice != null)
                    Text(
                      product.formattedOriginalPrice!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: soldPercent / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Đã bán ${soldPercent.toInt()}%',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.red,
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