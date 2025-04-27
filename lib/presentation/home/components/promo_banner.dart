import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final String? imagePath;

  const PromoBanner({
    Key? key,
    required this.title,
    required this.subtitle,
    this.buttonText = 'Mua ngay',
    this.onButtonPressed,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade900],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: imagePath != null
                ? Image.asset(
                    imagePath!,
                    errorBuilder: (context, error, stackTrace) => 
                        _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onButtonPressed ?? () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade900,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: const Icon(Icons.smartphone, size: 60, color: Colors.white),
    );
  }
}