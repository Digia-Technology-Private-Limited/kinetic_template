import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const CircularIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor = AppColors.bgLight2,
    this.iconColor = AppColors.black100,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: size * 0.5),
      ),
    );
  }
}

class BackArrowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const BackArrowButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CircularIconButton(
      icon: Icons.arrow_back_ios_new,
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
    );
  }
}

class RightArrowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const RightArrowButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: AppColors.black100,
    );
  }
}

class HeartButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback? onTap;

  const HeartButton({super.key, this.isLiked = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white100, // Usually white bg on images
        ),
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? AppColors.red : AppColors.black100,
          size: 20,
        ),
      ),
    );
  }
}

class CheckButton extends StatelessWidget {
  final bool isChecked;
  final VoidCallback? onTap;

  const CheckButton({super.key, this.isChecked = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked ? AppColors.primary100 : Colors.transparent,
          border: isChecked
              ? null
              : Border.all(color: AppColors.black100, width: 2),
        ),
        child: isChecked
            ? const Icon(Icons.check, size: 16, color: AppColors.white100)
            : null,
      ),
    );
  }
}

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const QuantityButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height:
            32, // User requested "PlusButton" / "MinusButton" - standardizing
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.bgLight2,
        ),
        child: Icon(icon, size: 16, color: AppColors.black100),
      ),
    );
  }
}
