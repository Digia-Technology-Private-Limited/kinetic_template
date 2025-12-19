import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/list_items.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final notifications = [
      {
        'msg':
            'Gilbert, you placed and order check your order history for full details',
        'time': DateTime.now(),
      },
      {
        'msg':
            'Gilbert, Thank you for shopping with us we have canceled order #24568.',
        'time': DateTime.now(),
      },
      {
        'msg':
            'Gilbert, your Order #24568 has been confirmed check your order history for full details',
        'time': DateTime.now(),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: AppTextStyles.h2Medium.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off_outlined, size: 64),
                  const SizedBox(height: 16),
                  Text("No Notification yet", style: AppTextStyles.h2Medium),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary100,
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Explore Categories",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                return NotificationListItem(
                  message: n['msg'] as String,
                  time: n['time'] as DateTime,
                );
              },
            ),
    );
  }
}
