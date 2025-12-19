import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CartSummary extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;

  const CartSummary({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgLight2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildRow('Subtotal', subtotal),
          const SizedBox(height: 8),
          _buildRow('Tax (10%)', tax),
          const SizedBox(height: 8),
          _buildRow(
            'Shipping',
            shipping,
            subtitle: shipping == 0 ? 'Free' : null,
          ),
          const Divider(height: 24),
          _buildRow('Total', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    double amount, {
    bool isTotal = false,
    String? subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: isTotal
                  ? AppTextStyles.bodyLargeBold
                  : AppTextStyles.bodyLargeMedium,
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: AppTextStyles.bodySmallMedium.copyWith(
                  color: Colors.green,
                ),
              ),
          ],
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: isTotal
              ? AppTextStyles.h2Medium.copyWith(
                  fontSize: 20,
                  color: AppColors.primary100,
                )
              : AppTextStyles.bodyLargeMedium,
        ),
      ],
    );
  }
}
