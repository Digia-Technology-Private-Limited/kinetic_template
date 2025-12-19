import 'package:flutter/foundation.dart';
import 'package:moengage_flutter/moengage_flutter.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final MoEngageFlutter _moEngagePlugin = MoEngageFlutter("<YOUR_APP_ID>");

  // Initialize (called from main.dart)
  Future<void> initialize() async {
    try {
      _moEngagePlugin.initialise();
      debugPrint('Analytics initialized');
    } catch (e) {
      debugPrint('Analytics initialization error: $e');
    }
  }

  // Track Product Viewed
  void trackProductViewed({
    required String productId,
    required String productName,
    required double price,
    String? category,
  }) {
    try {
      final properties = MoEProperties();
      properties.addAttribute('product_id', productId);
      properties.addAttribute('product_name', productName);
      properties.addAttribute('price', price);
      if (category != null) {
        properties.addAttribute('category', category);
      }
      _moEngagePlugin.trackEvent('product_viewed', properties);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Track Product Added to Cart
  void trackAddToCart({
    required String productId,
    required String productName,
    required double price,
    required int quantity,
  }) {
    try {
      final properties = MoEProperties();
      properties.addAttribute('product_id', productId);
      properties.addAttribute('product_name', productName);
      properties.addAttribute('price', price);
      properties.addAttribute('quantity', quantity);
      properties.addAttribute('total_value', price * quantity);
      _moEngagePlugin.trackEvent('add_to_cart', properties);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Track Product Removed from Cart
  void trackRemoveFromCart({
    required String productId,
    required String productName,
  }) {
    try {
      final properties = MoEProperties();
      properties.addAttribute('product_id', productId);
      properties.addAttribute('product_name', productName);
      _moEngagePlugin.trackEvent('remove_from_cart', properties);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Track Product Liked
  void trackProductLiked({
    required String productId,
    required String productName,
  }) {
    try {
      final properties = MoEProperties();
      properties.addAttribute('product_id', productId);
      properties.addAttribute('product_name', productName);
      _moEngagePlugin.trackEvent('product_liked', properties);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Track Product Unliked
  void trackProductUnliked({
    required String productId,
    required String productName,
  }) {
    try {
      final properties = MoEProperties();
      properties.addAttribute('product_id', productId);
      properties.addAttribute('product_name', productName);
      _moEngagePlugin.trackEvent('product_unliked', properties);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Track Checkout Initiated
  void trackCheckoutInitiated({
    required double totalAmount,
    required int itemCount,
  }) {
    try {
      final properties = MoEProperties();
      properties.addAttribute('total_amount', totalAmount);
      properties.addAttribute('item_count', itemCount);
      _moEngagePlugin.trackEvent('checkout_initiated', properties);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Track Payment Initiated
  void trackPaymentInitiated({
    required String orderId,
    required double amount,
  }) {
    try {
      final properties = MoEProperties();
      properties.addAttribute('order_id', orderId);
      properties.addAttribute('amount', amount);
      _moEngagePlugin.trackEvent('payment_initiated', properties);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Track Payment Successful
  void trackPaymentSuccess({
    required String orderId,
    required double amount,
    String? paymentMethod,
  }) {
    try {
      final properties = MoEProperties();
      properties.addAttribute('order_id', orderId);
      properties.addAttribute('amount', amount);
      if (paymentMethod != null) {
        properties.addAttribute('payment_method', paymentMethod);
      }
      _moEngagePlugin.trackEvent('payment_successful', properties);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Track Payment Failed
  void trackPaymentFailed({
    required String orderId,
    required double amount,
    String? errorReason,
  }) {
    try {
      final properties = MoEProperties();
      properties.addAttribute('order_id', orderId);
      properties.addAttribute('amount', amount);
      if (errorReason != null) {
        properties.addAttribute('error_reason', errorReason);
      }
      _moEngagePlugin.trackEvent('payment_failed', properties);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Track Product Shared
  void trackProductShared({
    required String productId,
    required String productName,
  }) {
    try {
      final properties = MoEProperties();
      properties.addAttribute('product_id', productId);
      properties.addAttribute('product_name', productName);
      _moEngagePlugin.trackEvent('product_shared', properties);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Track Screen View
  void trackScreenView(String screenName) {
    try {
      final properties = MoEProperties();
      properties.addAttribute('screen_name', screenName);
      _moEngagePlugin.trackEvent('screen_view', properties);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  // Set User Attributes
  void setUserAttributes({
    String? userId,
    String? email,
    String? name,
    String? phone,
  }) {
    try {
      if (userId != null) {
        _moEngagePlugin.setUniqueId(userId);
      }
      if (email != null) {
        _moEngagePlugin.setEmail(email);
      }
      if (name != null) {
        _moEngagePlugin.setUserName(name);
      }
      if (phone != null) {
        _moEngagePlugin.setPhoneNumber(phone);
      }
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }
}
