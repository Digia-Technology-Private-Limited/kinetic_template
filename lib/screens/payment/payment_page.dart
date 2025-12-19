import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/toast_utils.dart';
import '../../data/services/dio_client.dart';
import '../../data/services/cashfree_service.dart';
import '../../data/services/analytics_service.dart';
import '../order/order_confirmation_page.dart';

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
  late CFPaymentGatewayService _cfPaymentGatewayService;
  late CashfreeService _cashfreeService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cfPaymentGatewayService = CFPaymentGatewayService();
    _cfPaymentGatewayService.setCallback(_verifyPayment, _onError);
    _cashfreeService = CashfreeService(
      Provider.of<DioClient>(context, listen: false).dio,
    );
  }

  void _verifyPayment(String orderId) {
    print("Payment Successful - Order ID: $orderId");

    // Track payment success
    AnalyticsService().trackPaymentSuccess(
      orderId: orderId,
      amount: widget.amount,
      paymentMethod: 'Cashfree',
    );

    ToastUtils.showSuccess("Payment Successful!");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            OrderConfirmationPage(orderId: orderId, amount: widget.amount),
      ),
    );
  }

  void _onError(CFErrorResponse errorResponse, String orderId) {
    print("Payment Error: ${errorResponse.getMessage()}");

    // Track payment failure
    AnalyticsService().trackPaymentFailed(
      orderId: orderId,
      amount: widget.amount,
      errorReason: errorResponse.getMessage(),
    );

    ToastUtils.showError("Payment failed: ${errorResponse.getMessage()}");
    Navigator.pop(context);
  }

  Future<void> _initiatePayment() async {
    setState(() => _isLoading = true);

    try {
      final session = await _cashfreeService.createPaymentSession(
        amount: widget.amount,
        customerName: widget.customerName,
        customerEmail: widget.customerEmail,
        customerPhone: widget.customerPhone,
        orderId: widget.orderId,
      );

      if (session == null) {
        ToastUtils.showError("Failed to create payment session");
        setState(() => _isLoading = false);
        return;
      }

      // Track payment initiation
      AnalyticsService().trackPaymentInitiated(
        orderId: widget.orderId,
        amount: widget.amount,
      );

      final cfDropCheckout = CFDropCheckoutPaymentBuilder()
          .setSession(session)
          .build();

      _cfPaymentGatewayService.doPayment(cfDropCheckout);
    } on CFException catch (e) {
      ToastUtils.showError(e.message);
      print("Cashfree Exception: ${e.message}");
    } catch (e) {
      ToastUtils.showError("Payment initialization failed");
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
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
                    "You will be redirected to Cashfree's secure payment gateway",
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
