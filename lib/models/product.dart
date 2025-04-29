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
  final String id;
  final String name;
  final String image;
  final int price;
  final int? originalPrice; 
  final String? discountPercent; 
  final double rating;
  final int reviews;
  final bool isAvailable;
  final List<String> colors;
  final dynamic specifications; // Changed to dynamic to accept both types
  final bool isHot;
  final bool isNew; 
  final bool isFreeShipping;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    required this.rating,
    required this.reviews,
    this.isAvailable = true,
    required this.colors,
    required this.specifications,
    this.isHot = false,
    this.isNew = false,
    this.isFreeShipping = true,
  });

  factory Product.fromLegacy({
    required String id,
    required String name,
    required String image,
    required int price,
    int? originalPrice,
    String? discountPercent,
    double? rating,
    int reviews = 0,
    bool isAvailable = true,
    List<String> colors = const [],
    bool isHot = false,
    Map<String, String> specifications = const {},
  }) {
    return Product(
      id: id,
      name: name,
      image: image,
      price: price,
      originalPrice: originalPrice,
      discountPercent: discountPercent,
      rating: rating ?? 0.0,
      reviews: reviews,
      isAvailable: isAvailable,
      colors: colors,
      isHot: isHot,
      specifications: ProductSpecification.fromMap(specifications),
    );
  }

  int? get discountPercentValue {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) * 100 / originalPrice!).round();
    }
    return null;
  }

  String get formattedPrice {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(price);
  }

  String? get formattedOriginalPrice {
    if (originalPrice == null) return null;
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(originalPrice!);
  }
}