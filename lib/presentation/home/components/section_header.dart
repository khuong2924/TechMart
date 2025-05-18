import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showViewAll;
  final Color? titleColor;
  final double? fontSize;
  final IconData? icon;
  final VoidCallback? onViewAll;

  const SectionHeader({
    Key? key,
    required this.title,
    this.showViewAll = false,
    this.titleColor,
    this.fontSize,
    this.icon,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: titleColor ?? Colors.black, size: fontSize != null ? fontSize! * 1.2 : 22),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize ?? 18,
            fontWeight: FontWeight.bold,
            color: titleColor ?? Colors.black,
          ),
        ),
        const Spacer(),
        if (showViewAll)
          TextButton(
            onPressed: onViewAll,
            child: const Text('Xem tất cả'),
          ),
      ],
    );
  }
}