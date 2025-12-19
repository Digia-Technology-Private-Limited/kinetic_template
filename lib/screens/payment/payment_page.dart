import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/toast_utils.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  final String orderId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;

  const PaymentPage({
    super.key,
    required this.amount,
    required this.orderId,
    this.customerName = "John Doe",
    this.customerEmail = "customer@example.com",
    this.customerPhone = "9999999999",
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initiatePayment() async {
    setState(() => _isLoading = true);
    ToastUtils.showError("Payment initialization failed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        title: Text(
          "Payment",
          style: AppTextStyles.h2Medium.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary100),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.bgLight2,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order Summary",
                          style: AppTextStyles.h2Medium.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order ID:",
                              style: AppTextStyles.bodyLargeMedium,
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
                              "Total Amount:",
                              style: AppTextStyles.bodyLargeMedium,
                            ),
                            Text(
                              "\$${widget.amount.toStringAsFixed(2)}",
                              style: AppTextStyles.h2Medium.copyWith(
                                fontSize: 24,
                                color: AppColors.primary100,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Payment Methods",
                    style: AppTextStyles.h2Medium.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "You will be redirected to the payment gateway",
                    style: AppTextStyles.bodyMediumMedium.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _initiatePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Proceed to Payment",
                        style: AppTextStyles.bodyLargeBold.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
