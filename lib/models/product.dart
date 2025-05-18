import 'package:intl/intl.dart';
import 'package:tech_mart/models/product_specification.dart';

class ProductSpecification {
  const ProductSpecification();

  factory ProductSpecification.fromMap(Map<String, String> map) {
    // Implement the conversion logic here
    return ProductSpecification();
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final String imageUrl;
  final bool active;
  final double discountPercentage;
  final double? averageRating;
  final int reviewCount;
  final Map<String, dynamic> category;
  final List<dynamic> variants;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Mock data for UI
  final List<String> colors = ['Đen', 'Trắng', 'Xanh'];
  final bool isFreeShipping = true;
  final bool isHot = false;
  final bool isNew = true;
  final Map<String, String> specifications = {
    "Màn hình": "6.7 inch, OLED",
    "Chip": "Snapdragon 8 Gen 2",
    "RAM": "8 GB",
    "Bộ nhớ trong": "256 GB",
    "Camera sau": "50MP + 48MP + 32MP",
    "Camera trước": "16MP",
    "Pin": "5000 mAh, sạc nhanh 100W"
  };

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.imageUrl,
    required this.active,
    required this.discountPercentage,
    this.averageRating,
    required this.reviewCount,
    required this.category,
    required this.variants,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stockQuantity'],
      imageUrl: json['imageUrl'],
      active: json['active'],
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      averageRating: json['averageRating'] != null ? (json['averageRating'] as num).toDouble() : null,
      reviewCount: json['reviewCount'],
      category: json['category'],
      variants: json['variants'] ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Helper getters for UI
  bool get isAvailable => active && stockQuantity > 0;
  double get rating => averageRating ?? 0.0;
  int get reviews => reviewCount;
  String get categoryName => category['name'] ?? '';
  int get categoryId => category['id'] ?? 0;
  double get originalPrice => price / (1 - discountPercentage / 100);
  String? get discountPercent => discountPercentage > 0 ? '${discountPercentage.toStringAsFixed(0)}%' : null;

  String get formattedPrice {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(price);
  }

  String get formattedOriginalPrice {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(originalPrice);
  }
}