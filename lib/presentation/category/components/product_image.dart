import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String categoryName;
  
  const ProductImage({
    Key? key, 
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildProductImage(categoryName);
  }

  Widget _buildProductImage(String category) {
    // Use different placeholder based on category
    String assetPath;
    
    switch (category.toLowerCase()) {
      case 'laptops':
        assetPath = 'assets/images/laptop_placeholder.png';
        break;
      case 'smartphones':
        assetPath = 'assets/images/smartphone_placeholder.png';
        break;
      case 'accessories':
        assetPath = 'assets/images/accessories_placeholder.png';
        break;
      case 'audio':
        assetPath = 'assets/images/audio_placeholder.png';
        break;
      default:
        assetPath = 'assets/images/placeholder.png';
    }

    // Try to load from assets, but have a fallback if the asset doesn't exist
    try {
      return Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to a simple placeholder with icon
          return _buildIconPlaceholder(category);
        },
      );
    } catch (e) {
      return _buildIconPlaceholder(category);
    }
  }

  Widget _buildIconPlaceholder(String category) {
    // Choose icon based on category
    IconData icon;
    switch (category.toLowerCase()) {
      case 'laptops':
        icon = Icons.laptop;
        break;
      case 'smartphones':
        icon = Icons.smartphone;
        break;
      case 'accessories':
        icon = Icons.headphones;
        break;
      case 'audio':
        icon = Icons.speaker;
        break;
      default:
        icon = Icons.devices_other;
    }

    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey[600], size: 40),
            const SizedBox(height: 4),
            Text(
              category,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}