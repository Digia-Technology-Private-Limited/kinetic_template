import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/icon_buttons.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/checkout/progress_indicator.dart';
import '../payment/payment_page.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/utils/id_generator.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/cart/cart_summary.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        leading: BackArrowButton(onPressed: () => Navigator.pop(context)),
        title: Text(
          "Checkout",
          style: AppTextStyles.h2Medium.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const CheckoutProgressIndicator(
            currentStep: 2, // Payment step
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Shipping Address", style: AppTextStyles.bodyLargeBold),
                  const SizedBox(height: 16),
                  // Mock Address Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgLight2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.white100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: AppColors.primary100,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Home", style: AppTextStyles.bodyLargeBold),
                              Text(
                                "1234 Main St, City, Country",
                                style: AppTextStyles.bodySmallMedium.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.edit,
                          color: AppColors.primary100,
                          size: 20,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  Text("Order Summary", style: AppTextStyles.bodyLargeBold),
                  const SizedBox(height: 16),
                  CartSummary(
                    subtotal: cart.subtotal,
                    tax: cart.tax,
                    shipping: cart.shipping,
                    total: cart.total,
                  ),
                  const SizedBox(height: 32),
                  Text("Payment Method", style: AppTextStyles.bodyLargeBold),
                  const SizedBox(height: 16),
                  // Mock Payment
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgLight2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.white100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.credit_card,
                            color: AppColors.primary100,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Visa Ending in 4242",
                                style: AppTextStyles.bodyLargeBold,
                              ),
                              Text(
                                "**/**",
                                style: AppTextStyles.bodySmallMedium.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primary100,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  PrimaryButton(
                    text: "Continue to Payment",
                    onPressed: () {
                      if (cart.itemCount == 0) {
                        ToastUtils.showError('Your cart is empty');
                        return;
                      }

                      // Generate order ID
                      final orderId = IdGenerator.generateOrderId();

                      // Navigate to payment page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentPage(
                            amount: cart.total,
                            orderId: orderId,
                            customerName: "John Doe",
                            customerEmail: "customer@example.com",
                            customerPhone: "9999999999",
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
