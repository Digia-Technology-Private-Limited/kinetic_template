import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ReviewsItem extends StatelessWidget {
  final String name;
  final double rating;
  final String comment;
  final String? avatarUrl;

  const ReviewsItem({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : null,
            child: avatarUrl == null ? const Icon(Icons.person) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: AppTextStyles.bodyLargeBold),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 16,
                          color: AppColors.yellow,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment, style: AppTextStyles.bodySmallMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationListItem extends StatelessWidget {
  final String message;
  final bool isRead; // For styling dot
  final DateTime time; // Display relative time potentially

  const NotificationListItem({
    super.key,
    required this.message,
    this.isRead = false,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgLight2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {}, // Bell icon
            child: const Icon(Icons.notifications, color: AppColors.black100),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(message, style: AppTextStyles.bodySmallMedium)),
        ],
      ),
    );
  }
}
