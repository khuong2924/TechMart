import 'package:flutter/material.dart';

class PromotionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color textColor;
  final IconData icon;
  final VoidCallback? onTap;

  const PromotionCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.textColor,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isSmallScreen ? 120 : 140,
        height: isSmallScreen ? 120 : 140,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(isSmallScreen ? 10 : 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgColor, bgColor.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: textColor.withOpacity(0.13),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: textColor.withOpacity(0.18), width: 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [textColor.withOpacity(0.85), textColor.withOpacity(0.55)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
              child: Icon(icon, color: Colors.white, size: isSmallScreen ? 24 : 28),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isSmallScreen ? 11 : 12,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ]
          ],
        ),
      ),
    );
  }
}