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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.contain,
                  ),
                ),
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
}