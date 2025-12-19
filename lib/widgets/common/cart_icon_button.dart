import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CartIconButton extends StatelessWidget {
  final int itemCount;
  final VoidCallback onTap;

  const CartIconButton({
    super.key,
    required this.itemCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors
                  .primary100, // as per design first page top right, purple button with bag
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.white100,
              size: 20,
            ),
          ),
          if (itemCount > 0)
            Positioned(
              right: -4,
              top: -4, // Adjust for logic
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.red, // Or yellow
                ),
                child: Text(
                  itemCount > 9 ? '9+' : itemCount.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
