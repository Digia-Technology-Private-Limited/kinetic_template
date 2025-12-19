import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/primary_button.dart';

class OrderConfirmationPage extends StatefulWidget {
  final String orderId;
  final double amount;

  const OrderConfirmationPage({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  @override
  void initState() {
    super.initState();
    // Clear cart after successful order
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().clearCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back button, force user to use "Continue Shopping"
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white100,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Order Placed Successfully!",
                  style: AppTextStyles.h2Medium.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "Thank you for your purchase",
                  style: AppTextStyles.bodyLargeMedium.copyWith(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.bgLight2,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order ID",
                            style: AppTextStyles.bodyLargeMedium.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            widget.orderId,
                            style: AppTextStyles.bodyLargeBold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Amount Paid",
                            style: AppTextStyles.bodyLargeMedium.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "\$${widget.amount.toStringAsFixed(2)}",
                            style: AppTextStyles.h2Medium.copyWith(
                              fontSize: 20,
                              color: AppColors.primary100,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status",
                            style: AppTextStyles.bodyLargeMedium.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Confirmed",
                              style: AppTextStyles.bodySmallBold.copyWith(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "You will receive an order confirmation email shortly",
                          style: AppTextStyles.bodySmallMedium.copyWith(
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  text: "Continue Shopping",
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    // Navigate to orders page (placeholder)
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary100),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: Text(
                    "Track Order",
                    style: AppTextStyles.bodyLargeBold.copyWith(
                      color: AppColors.primary100,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
