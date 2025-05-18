import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showViewAll;
  final VoidCallback? onViewAllPressed;
  final Color titleColor;

  const SectionHeader({
    Key? key,
    required this.title,
    this.showViewAll = true,
    this.onViewAllPressed,
    this.titleColor = Colors.black,
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          if (showViewAll)
            TextButton(
              onPressed: onViewAllPressed ?? () {},
              child: Row(
                children: [
                  Text(
                    'Xem thêm',
                    style: TextStyle(color: Colors.blue.shade200),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Colors.blue.shade200,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}