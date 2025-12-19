import 'dart:convert';
import 'package:flutter/material.dart';
import '../data/services/api_service.dart';
import '../data/services/storage_service.dart';
import '../data/models/cart_models.dart';
import '../data/models/catalog_models.dart';
import '../core/utils/toast_utils.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService;
  final StorageService? _storageService;

  CartProvider(this._apiService, [this._storageService]);

  Cart? _cart;
  Cart? get cart => _cart;

  List<LocalCartItem> _localCartItems = [];
  List<LocalCartItem> get localCartItems => _localCartItems;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Initialize: check if we have a stored cart ID and load local cart
  Future<void> init() async {
    await _loadLocalCart();
    final storedCartId = _storageService?.getCartId();
    if (storedCartId != null) {
      await fetchCart(storedCartId);
    }
  }

  Future<void> _loadLocalCart() async {
    final cartJson = _storageService?.getLocalCart();
    if (cartJson != null && cartJson.isNotEmpty) {
      try {
        final List<dynamic> itemsJson = jsonDecode(cartJson);
        _localCartItems = itemsJson
            .map((item) => LocalCartItem.fromJson(item))
            .toList();
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading local cart: $e');
      }
    }
  }

  Future<void> _saveLocalCart() async {
    final itemsJson = _localCartItems.map((item) => item.toJson()).toList();
    await _storageService?.saveLocalCart(jsonEncode(itemsJson));
    _updateCounter();
  }

  Future<void> fetchCart(String cartId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getCart(cartId);
      if (response.data != null && response.data['data']['cart'] != null) {
        _cart = Cart.fromJson(response.data['data']['cart']);
        _updateCounter();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(
    Product product,
    int quantity, {
    String? size,
    String? color,
  }) async {
    _errorMessage = null;

    try {
      // Check if product already exists in local cart
      final existingIndex = _localCartItems.indexWhere(
        (item) =>
            item.product.id == product.id &&
            item.selectedSize == size &&
            item.selectedColor == color,
      );

      if (existingIndex != -1) {
        // Update quantity
        _localCartItems[existingIndex] = _localCartItems[existingIndex]
            .copyWith(
              quantity: _localCartItems[existingIndex].quantity + quantity,
            );
      } else {
        // Add new item
        _localCartItems.add(
          LocalCartItem(
            product: product,
            quantity: quantity,
            selectedSize: size,
            selectedColor: color,
          ),
        );
      }

      await _saveLocalCart();
      ToastUtils.showSuccess('Item added to cart!');
    } catch (e) {
      _errorMessage = e.toString();
      ToastUtils.showError('Failed to add item to cart');
    } finally {
      notifyListeners();
    }
  }

  Future<void> removeFromCart(int index) async {
    if (index >= 0 && index < _localCartItems.length) {
      _localCartItems.removeAt(index);
      await _saveLocalCart();
      ToastUtils.showInfo('Item removed from cart');
      notifyListeners();
    }
  }

  Future<void> updateQuantity(int index, int newQuantity) async {
    if (index >= 0 && index < _localCartItems.length) {
      if (newQuantity <= 0) {
        await removeFromCart(index);
      } else {
        _localCartItems[index] = _localCartItems[index].copyWith(
          quantity: newQuantity,
        );
        await _saveLocalCart();
        notifyListeners();
      }
    }
  }

  Future<void> clearCart() async {
    _localCartItems.clear();
    await _storageService?.clearLocalCart();
    ToastUtils.showSuccess('Cart cleared');
    notifyListeners();
  }

  double get subtotal {
    return _localCartItems.fold(0.0, (sum, item) => sum + item.itemTotal);
  }

  double get tax {
    return subtotal * 0.1; // 10% tax
  }

  double get shipping {
    return subtotal > 50 ? 0.0 : 5.0; // Free shipping over $50
  }

  double get total {
    return subtotal + tax + shipping;
  }

  int get itemCount {
    return _localCartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  void _updateCounter() {
    _storageService?.saveCartCounter(itemCount);
  }
}
