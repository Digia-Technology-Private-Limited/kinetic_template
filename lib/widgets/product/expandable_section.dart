import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ExpandableSection extends StatelessWidget {
  final String title;
  final Widget content;
  final bool initiallyExpanded;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded: initiallyExpanded,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.bgLight2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            tapBodyToCollapse: false,
            hasIcon: true,
            iconColor: AppColors.black100,
            iconSize: 24,
          ),
          header: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: AppTextStyles.bodyLargeBold,
            ),
          ),
          collapsed: const SizedBox.shrink(),
          expanded: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: content,
          ),
        ),
      ),
    );
  }
}

