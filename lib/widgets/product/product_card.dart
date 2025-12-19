import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/catalog_models.dart'; // Ensure this model exists
import '../common/icon_buttons.dart';
import '../../providers/wishlist_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showLikeButton;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showLikeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.bgLight2,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: product.featuredImage != null
                        ? OctoImage(
                            image: NetworkImage(product.featuredImage!),
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, progress) =>
                                Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary100,
                                  ),
                                ),
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                          )
                        : const Center(
                            child: Icon(Icons.image, color: Colors.grey),
                          ),
                  ),
                ),
                if (showLikeButton)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<WishlistProvider>(
                      builder: (context, wishlist, _) {
                        final isLiked = wishlist.isLiked(product.id);
                        return HeartButton(
                          isLiked: isLiked,
                          onTap: () {
                            wishlist.toggleLike(product.id);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.title,
            style: AppTextStyles.bodySmallMedium.copyWith(
              color: AppColors.black100,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
            style: AppTextStyles.bodySmallBold.copyWith(
              color: AppColors.black100,
            ),
          ),
        ],
      ),
    );
  }
}
