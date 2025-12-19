import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if empty or list
    // Mock List
    final orders = [
      {'id': '#456765', 'status': 'Shipping', 'items': 4},
      {'id': '#454569', 'status': 'Delivered', 'items': 2},
      {'id': '#454809', 'status': 'Canceled', 'items': 1},
    ];

    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(title: const Text("Orders"), centerTitle: true),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 80),
                  const SizedBox(height: 16),
                  Text("No Orders yet", style: AppTextStyles.h2Medium),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Explore Categories"),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.bgLight2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order ${order['id']}",
                              style: AppTextStyles.bodyLargeBold,
                            ),
                            Text(
                              "${order['items']} items",
                              style: AppTextStyles.bodySmallMedium.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
