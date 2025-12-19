import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class LoadingState extends StatelessWidget {
  final bool useLottie;
  const LoadingState({super.key, this.useLottie = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: useLottie
          ? CircularProgressIndicator(
              color: AppColors.primary100,
            ) // Placeholder for Lottie if URL not known, or use standard
          : CircularProgressIndicator(color: AppColors.primary100),
    );
  }
}

// Fallback for empty/error
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({Key? key, required this.message, this.onRetry})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.red),
          SizedBox(height: 16),
          Text(message),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: Text("Retry")),
        ],
      ),
    );
  }
}
