import 'package:flutter/material.dart';
import 'package:widget_marquee/widget_marquee.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AnnouncementBanner extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const AnnouncementBanner({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: backgroundColor ?? AppColors.primary100,
      child: Marquee(
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor ?? Colors.white),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: AppTextStyles.bodySmallMedium.copyWith(
                color: textColor ?? Colors.white,
              ),
            ),
            const SizedBox(width: 40), // Spacing between repeats
          ],
        ),
      ),
    );
  }
}
