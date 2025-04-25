import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String rating;
  final String title;
  final String price;
  final String originalPrice;
  final String discount;
  final String imageUrl;

  const ProductCard({
    Key? key,
    required this.rating,
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFF0F0F0),
            blurRadius: 0,
            offset: Offset(0, 1.50),
          ),
          BoxShadow(
            color: Color(0xFFF0F0F0),
            blurRadius: 0,
            offset: Offset(-1.50, 0),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: ShapeDecoration(
                color: const Color(0xFF191919),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                rating,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            
            // Product image
            Center(
              child: Container(
                height: 103,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: _buildProductImage(),
              ),
            ),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w400,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Price section
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: price,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: originalPrice,
                    style: const TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 12,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: discount,
                    style: const TextStyle(
                      color: Color(0xFF26A541),
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Exchange offer
            Row(
              children: const [
                Icon(Icons.local_offer_outlined, size: 10, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  'Exchange Offer & more',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 10,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    // First try to use a default asset placeholder
    try {
      return Image.asset(
        'assets/images/placeholder.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fall back to a simple placeholder with icon
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.devices_other, color: Colors.grey[500], size: 30),
                  const SizedBox(height: 4),
                  Text(
                    "Product",
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      // Fall back to icon if asset loading fails for any reason
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.devices_other, color: Colors.grey[500], size: 30),
              const SizedBox(height: 4),
              Text(
                "Product",
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }
  }
}