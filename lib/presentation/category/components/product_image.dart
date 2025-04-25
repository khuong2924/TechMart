import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String categoryName;
  
  const ProductImage({
    Key? key, 
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildIconPlaceholder(categoryName);
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