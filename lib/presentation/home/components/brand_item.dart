import 'package:flutter/material.dart';

class BrandItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final double? iconSize;
  final VoidCallback? onTap;

  const BrandItem({
    Key? key,
    required this.name,
    required this.icon,
    this.iconSize,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: iconSize ?? 28, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}