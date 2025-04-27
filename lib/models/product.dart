import 'package:intl/intl.dart';

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
  final Map<String, String> specifications;
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