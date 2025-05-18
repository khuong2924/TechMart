import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final TextEditingController? controller;

  const CustomSearchBar({
    Key? key,
    this.hintText = 'Tìm kiếm sản phẩm...',
    this.onTap,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMediumScreen = size.width >= 600 && size.width < 1200;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
      child: TextField(
        controller: controller,
        onTap: onTap,
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 16,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: Colors.grey[600],
          ),
          prefixIcon: Icon(
            Icons.search,
            size: isSmallScreen ? 20 : 24,
            color: Colors.grey[600],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 12 : 14,
            horizontal: isSmallScreen ? 12 : 16,
          ),
        ),
      ),
    );
  }
}