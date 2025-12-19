import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/main/nav_bar_page.dart';
import '../../screens/shop/selected_category_page.dart';
import '../../screens/pdp/product_details_page.dart';
import '../../screens/cart/cart_page.dart';
import '../../screens/checkout/checkout_page.dart';
import '../../screens/auth/otp_verification_page.dart';
import '../../screens/profile/profile_page.dart';
import '../../screens/profile/help_center_page.dart';
import '../../screens/profile/about_page.dart';
import '../../data/models/catalog_models.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const NavBarPage(),
      ),
      GoRoute(
        path: '/category/:handle',
        name: 'category',
        builder: (context, state) {
          final handle = state.pathParameters['handle']!;
          final title = state.uri.queryParameters['title'] ?? 'Category';
          return SelectedCategoryPage(
            handle: handle,
            title: title,
          );
        },
      ),
      GoRoute(
        path: '/product/:id',
        name: 'product',
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailsPage(product: product);
        },
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: '/otp-verification',
        name: 'otp-verification',
        builder: (context, state) {
          final phoneNumber = state.uri.queryParameters['phone'] ?? '';
          final onVerified = state.extra as VoidCallback?;
          return OTPVerificationPage(
            phoneNumber: phoneNumber,
            onVerified: onVerified ?? () {},
          );
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/help-center',
        name: 'help-center',
        builder: (context, state) => const HelpCenterPage(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) {
          final isPrivacy = state.uri.queryParameters['privacy'] == 'true';
          final isTerms = state.uri.queryParameters['terms'] == 'true';
          return AboutPage(
            isPrivacyPolicy: isPrivacy,
            isTermsAndConditions: isTerms,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

