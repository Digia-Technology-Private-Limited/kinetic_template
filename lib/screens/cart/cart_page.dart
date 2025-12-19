import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/icon_buttons.dart';
import '../../widgets/cart/add_to_cart_button.dart';
import '../../widgets/cart/cart_item_card.dart';
import '../../widgets/cart/cart_summary.dart';
import '../checkout/checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.localCartItems;

    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        leading: BackArrowButton(onPressed: () => Navigator.pop(context)),
        title: Text(
          "My Cart (${cartProvider.itemCount})",
          style: AppTextStyles.h2Medium.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Cart'),
                    content: const Text(
                      'Are you sure you want to remove all items?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          cartProvider.clearCart();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'Clear',
                style: AppTextStyles.bodyMediumMedium.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Cart is Empty',
                    style: AppTextStyles.h2Medium.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add items to get started',
                    style: AppTextStyles.bodyMediumMedium.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CartItemCard(
                        item: item,
                        onRemove: () {
                          cartProvider.removeFromCart(index);
                        },
                        onQuantityChanged: (newQuantity) {
                          cartProvider.updateQuantity(index, newQuantity);
                        },
                      );
                    },
                  ),
                ),
                // Summary Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CartSummary(
                        subtotal: cartProvider.subtotal,
                        tax: cartProvider.tax,
                        shipping: cartProvider.shipping,
                        total: cartProvider.total,
                      ),
                      const SizedBox(height: 16),
                      AddToCartPlaceOrderButton(
                        price: "\$${cartProvider.total.toStringAsFixed(2)}",
                        buttonText: "Proceed to Checkout",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckoutPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
