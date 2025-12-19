import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ColorSelectionItem extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorSelectionItem({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: isSelected
            ? const Center(
                child: Icon(Icons.check, color: AppColors.white100, size: 16),
              )
            : null,
      ),
    );
  }
}

class SizeSelectionItem extends StatelessWidget {
  final String size;
  final bool isSelected;
  final VoidCallback onTap;

  const SizeSelectionItem({
    Key? key,
    required this.size,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.primary100 : AppColors.bgLight2,
        ),
        child: Text(
          size,
          style: isSelected
              ? AppTextStyles.bodySmallBold.copyWith(color: AppColors.white100)
              : AppTextStyles.bodySmallMedium.copyWith(
                  color: AppColors.black100,
                ),
        ),
      ),
    );
  }
}
