import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/icon_buttons.dart';
import '../../widgets/cart/add_to_cart_button.dart'; // Reuse button for "Checkout"

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cart = cartProvider.cart;

    // Handle empty or null cart
    if (cart == null || cart.lines.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Cart"), centerTitle: true),
        body: const Center(child: Text("Your Cart is Empty")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        title: const Text(
          "Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Could have "Remove All"
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.lines.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final line = cart.lines[index];
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        line.product.featuredImage ??
                            'https://via.placeholder.com/80',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            line.product.title,
                            style: AppTextStyles.bodyLargeBold,
                          ),
                          const SizedBox(height: 4),
                          // Variant title if available?
                          Text(
                            "\$${line.amountPerQuantity?.toStringAsFixed(2) ?? '0.00'}",
                            style: AppTextStyles.bodySmallBold,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              QuantityButton(
                                icon: Icons.remove,
                                onTap: () {
                                  if (line.quantity > 0) {
                                    // Update logic: q-1. If 0, maybe remove?
                                    context.read<CartProvider>().updateQuantity(
                                      line.id,
                                      line.quantity - 1,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "${line.quantity}",
                                style: AppTextStyles.bodySmallMedium,
                              ),
                              const SizedBox(width: 12),
                              QuantityButton(
                                icon: Icons.add,
                                onTap: () {
                                  context.read<CartProvider>().updateQuantity(
                                    line.id,
                                    line.quantity + 1,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Coupon code?

          // Summary
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subtotal",
                      style: AppTextStyles.bodyLargeMedium.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "\$${cart.subtotal.toStringAsFixed(2)}",
                      style: AppTextStyles.bodyLargeBold,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shipping Cost",
                      style: AppTextStyles.bodyLargeMedium.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    Text("\$8.00", style: AppTextStyles.bodyLargeBold),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tax",
                      style: AppTextStyles.bodyLargeMedium.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    Text("\$0.00", style: AppTextStyles.bodyLargeBold),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: AppTextStyles.bodyLargeMedium.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "\$${(cart.total + 8.00).toStringAsFixed(2)}",
                      style: AppTextStyles.bodyLargeBold,
                    ),
                  ],
                ),
              ],
            ),
          ),

          AddToCartPlaceOrderButton(
            price: "\$${(cart.total + 8.00).toStringAsFixed(2)}",
            buttonText: "Checkout",
            onPressed: () {
              // Navigate to simple Checkout Page
            },
          ),
        ],
      ),
    );
  }
}
