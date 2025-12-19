import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AddToCartPlaceOrderButton extends StatelessWidget {
  final String price; // "$148.00"
  final String buttonText; // "Add to Bag" or "Place Order"
  final VoidCallback? onPressed;

  const AddToCartPlaceOrderButton({
    super.key,
    required this.price,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors
            .black100, // Bottom bar usually black logic might differ if entire button or bar.
        // Based on user "add_to_cart_place_order_button", usually a bar with price on left/right and button.
        // Or a full width button.
        // Let's implement as a custom BottomSheet-like sticky button.
        // Actually, often designs have: [ Price ...  Button ]
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        // Handle iPhone bottom notch
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Price",
                  style: AppTextStyles.bodySmallMedium.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  price,
                  style: AppTextStyles.bodyLargeBold.copyWith(
                    color: AppColors.white100,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(
                buttonText,
                style: AppTextStyles.bodyLargeMedium.copyWith(
                  color: AppColors.white100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
