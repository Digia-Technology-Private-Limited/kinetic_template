import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CartBadge extends StatelessWidget {
  final Widget icon;
  final int count;

  const CartBadge({
    super.key,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primary100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

