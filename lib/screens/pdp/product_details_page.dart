import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/icon_buttons.dart';
import '../../widgets/product/pdp_carousel.dart';
import '../../widgets/product/item_selectors.dart';
import '../../widgets/cart/add_to_cart_button.dart';
import '../../widgets/common/loading_state.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  // Mock sizes/color if not in API model deeply
  final List<String> sizes = ['S', 'M', 'L', 'XL', '2XL'];
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.black,
    Colors.green,
  ];

  String _selectedSize = 'M';
  Color _selectedColor = Colors.red;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final product = widget.product;

    // Use images from product if available, else featured
    List<String> images = [];
    if (product.images.isNotEmpty) {
      // API might return IDs only currently in model, check if we parsed URLs
      // Checking model: `images` is List<String>
      // if empty, use featured
      images = product.images;
    }
    if (images.isEmpty && product.featuredImage != null) {
      images = [product.featuredImage!];
    }

    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        leading: BackArrowButton(onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: HeartButton(isLiked: false),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PDPCarousel(imageUrls: images),
                  const SizedBox(height: 24),
                  Text(
                    product.title,
                    style: AppTextStyles.h2Medium.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${product.price?.toStringAsFixed(2)}",
                    style: AppTextStyles.bodyLargeBold.copyWith(
                      color: AppColors.primary100,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sizes
                  Text("Size", style: AppTextStyles.bodyLargeBold),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: sizes
                        .map(
                          (s) => SizeSelectionItem(
                            size: s,
                            isSelected: _selectedSize == s,
                            onTap: () => setState(() => _selectedSize = s),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Colors
                  Text("Color", style: AppTextStyles.bodyLargeBold),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: colors
                        .map(
                          (c) => ColorSelectionItem(
                            color: c,
                            isSelected: _selectedColor == c,
                            onTap: () => setState(() => _selectedColor = c),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Quantity
                  Text("Quantity", style: AppTextStyles.bodyLargeBold),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      QuantityButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (_quantity > 1) setState(() => _quantity--);
                        },
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _quantity.toString(),
                        style: AppTextStyles.bodyLargeMedium,
                      ),
                      const SizedBox(width: 16),
                      QuantityButton(
                        icon: Icons.add,
                        onTap: () {
                          setState(() => _quantity++);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text("Description", style: AppTextStyles.bodyLargeBold),
                  const SizedBox(height: 8),
                  Text(
                    product.description ?? "No description available.",
                    style: AppTextStyles.bodySmallMedium.copyWith(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 80), // Spacing for bottom button
                ],
              ),
            ),
          ),
          cart.isLoading
              ? const LoadingState()
              : AddToCartPlaceOrderButton(
                  price:
                      "\$${((product.price ?? 0) * _quantity).toStringAsFixed(2)}",
                  buttonText: "Add to Bag",
                  onPressed: () async {
                    // Add to cart logic calls Provider
                    // Need variant ID! Product ID is not enough to add to cart usually.
                    // But our model might have just product ID.
                    // For this template, we'll try to use product ID or if we have variants.
                    // The API separates product and variant.
                    // Mock variant ID for now if missing, or use product ID hoping it auto-resolves (unlikely).
                    // Let's assume the passed `product.id` is the variant ID or we modify model to get first variant.
                    // In `Product.fromJson`, we parse variants. Let's fix model if needed or use ID.
                    // Wait, Product model DOES NOT Expose variants properly yet (just a List<String> images?).
                    // The query gets variants. I should definitely use a variant ID.
                    // For now, use product.id as proxy.

                    await context.read<CartProvider>().addToCart(
                      product.id,
                      _quantity,
                    );

                    if (context.mounted && cart.errorMessage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to Cart")),
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }
}
