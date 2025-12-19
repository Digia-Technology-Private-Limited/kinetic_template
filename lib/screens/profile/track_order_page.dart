import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/icon_buttons.dart';

class TrackOrderPage extends StatelessWidget {
  const TrackOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        leading: BackArrowButton(onPressed: () => Navigator.pop(context)),
        title: Text(
          "Track Order",
          style: AppTextStyles.h2Medium.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order #456765", style: AppTextStyles.h2),
            const SizedBox(height: 32),
            // Timeline
            _buildTimelineTile(
              title: "Delivered",
              date: "28 May",
              isCompleted: false,
              isFirst: true,
            ),
            _buildTimelineTile(
              title: "Shipped",
              date: "28 May",
              isCompleted: true,
            ),
            _buildTimelineTile(
              title: "Order Confirmed",
              date: "28 May",
              isCompleted: true,
            ),
            _buildTimelineTile(
              title: "Order Placed",
              date: "28 May",
              isCompleted: true,
              isLast: true,
            ),

            const SizedBox(height: 32),
            Text("Order Items", style: AppTextStyles.bodyLargeBold),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgLight2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long),
                  const SizedBox(width: 12),
                  Text("4 items", style: AppTextStyles.bodyLargeMedium),
                  const Spacer(),
                  Text(
                    "View All",
                    style: AppTextStyles.bodySmallBold.copyWith(
                      color: AppColors.primary100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTile({
    required String title,
    required String date,
    bool isCompleted = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(
                width: 2,
                height: 20,
                color: isCompleted ? AppColors.primary100 : Colors.grey[300],
              ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.primary100 : Colors.grey[200],
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey[300],
              ), // Line to next
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
            ), // Align with circle roughly
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: isCompleted
                      ? AppTextStyles.bodyLargeMedium
                      : AppTextStyles.bodyLargeMedium.copyWith(
                          color: Colors.grey,
                        ),
                ),
                Text(
                  date,
                  style: AppTextStyles.bodySmallMedium.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
