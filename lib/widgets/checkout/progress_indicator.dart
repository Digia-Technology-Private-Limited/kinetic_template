import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CheckoutProgressIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CheckoutProgressIndicator({
    super.key,
    required this.currentStep,
    this.steps = const ['Cart', 'Address', 'Payment', 'Review'],
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep / (steps.length - 1)).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white100,
      child: Column(
        children: [
          LinearPercentIndicator(
            lineHeight: 6,
            percent: progress,
            backgroundColor: AppColors.bgLight2,
            progressColor: AppColors.primary100,
            barRadius: const Radius.circular(3),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (index) {
              final isActive = index <= currentStep;
              final isCompleted = index < currentStep;

              return Expanded(
                child: Row(
                  children: [
                    _buildStepIndicator(
                      stepNumber: index + 1,
                      isActive: isActive,
                      isCompleted: isCompleted,
                      label: steps[index],
                    ),
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? AppColors.primary100
                              : AppColors.bgLight2,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator({
    required int stepNumber,
    required bool isActive,
    required bool isCompleted,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isActive
                ? AppColors.primary100
                : AppColors.bgLight2,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : Text(
                    stepNumber.toString(),
                    style: AppTextStyles.bodySmallBold.copyWith(
                      color: isActive ? Colors.white : AppColors.black50,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmallMedium.copyWith(
            fontSize: 10,
            color: isActive ? AppColors.black100 : AppColors.black50,
          ),
        ),
      ],
    );
  }
}

