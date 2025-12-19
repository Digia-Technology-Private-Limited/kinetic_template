import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/primary_button.dart';
import '../../core/utils/toast_utils.dart';

class SmsRetrieverImpl implements SmsRetriever {
  @override
  bool get listenForMultipleSms => false;
  @override
  Future<String?> getSmsCode() async {
    return null;
  }

  @override
  Future<void> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }
}

class OTPVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onVerified;

  const OTPVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.onVerified,
  });

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  final _smsRetriever = SmsRetrieverImpl();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startListeningForOtp();
  }

  Future<void> _startListeningForOtp() async {
    try {
      final sms = await _smsRetriever.getSmsCode();
      if (sms != null && mounted) {
        // Extract OTP from SMS (assuming it's 6 digits)
        final otpMatch = RegExp(r'\d{6}').firstMatch(sms);
        if (otpMatch != null) {
          _pinController.text = otpMatch.group(0)!;
          _verifyOtp();
        }
      }
    } catch (e) {
      debugPrint('Error listening for OTP: $e');
    }
  }

  Future<void> _verifyOtp() async {
    if (_pinController.text.length != 6) {
      ToastUtils.showError('Please enter a valid 6-digit OTP');
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      ToastUtils.showSuccess('OTP verified successfully!');
      widget.onVerified();
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: AppTextStyles.h2Medium.copyWith(fontSize: 20),
      decoration: BoxDecoration(
        color: AppColors.bgLight2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.black50.withOpacity(0.3)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.primary100, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.primary100.withOpacity(0.1),
        border: Border.all(color: AppColors.primary100),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black100),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verify Your Order",
                style: AppTextStyles.h2Medium.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Enter the 6-digit code sent to\n${widget.phoneNumber}",
                style: AppTextStyles.bodyLargeMedium.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Pinput(
                  controller: _pinController,
                  focusNode: _focusNode,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  autofocus: true,
                  onCompleted: (pin) => _verifyOtp(),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Resend OTP logic
                    ToastUtils.showInfo('OTP resent successfully');
                  },
                  child: Text(
                    "Didn't receive code? Resend",
                    style: AppTextStyles.bodyLargeMedium.copyWith(
                      color: AppColors.primary100,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary100,
                      ),
                    )
                  : PrimaryButton(
                      text: "Verify & Continue",
                      onPressed: _verifyOtp,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
