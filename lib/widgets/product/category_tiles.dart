import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CategoryHorizontal extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryHorizontal({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgLight2,
              image: DecorationImage(
                image: NetworkImage(imageUrl), // Usually categories have images
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.bodySmallMedium),
        ],
      ),
    );
  }
}

class CategoryVertical extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int count; // e.g. "Hoodies (240)"
  final VoidCallback onTap;

  const CategoryVertical({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.count,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgLight2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Text(title, style: AppTextStyles.bodyLargeMedium),
            // const Spacer(), // If we want arrow or trailing
          ],
        ),
      ),
    );
  }
}
