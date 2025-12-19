import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/cart_models.dart';

class CartItemCard extends StatelessWidget {
  final LocalCartItem item;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.product.featuredImage != null
                ? CachedNetworkImage(
                    imageUrl: item.product.featuredImage!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.bgLight2,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary100,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.bgLight2,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  )
                : Container(
                    width: 80,
                    height: 80,
                    color: AppColors.bgLight2,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
          ),
          const SizedBox(width: 12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  style: AppTextStyles.bodyLargeMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (item.selectedSize != null || item.selectedColor != null)
                  Text(
                    [
                      if (item.selectedSize != null)
                        'Size: ${item.selectedSize}',
                      if (item.selectedColor != null)
                        'Color: ${item.selectedColor}',
                    ].join(' • '),
                    style: AppTextStyles.bodySmallMedium.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.itemTotal.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyLargeBold.copyWith(
                        color: AppColors.primary100,
                      ),
                    ),
                    Row(
                      children: [
                        // Decrease button
                        InkWell(
                          onTap: () {
                            if (item.quantity > 1) {
                              onQuantityChanged(item.quantity - 1);
                            }
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.bgLight2,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.remove,
                              size: 16,
                              color: AppColors.black100,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            item.quantity.toString(),
                            style: AppTextStyles.bodyLargeMedium,
                          ),
                        ),
                        // Increase button
                        InkWell(
                          onTap: () {
                            onQuantityChanged(item.quantity + 1);
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Remove button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
