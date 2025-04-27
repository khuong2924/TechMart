import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showViewAll;
  final VoidCallback? onViewAllPressed;

  const SectionHeader({
    Key? key,
    required this.title,
    this.showViewAll = true,
    this.onViewAllPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showViewAll)
            TextButton(
              onPressed: onViewAllPressed ?? () {},
              child: Row(
                children: [
                  Text(
                    'Xem thêm',
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}