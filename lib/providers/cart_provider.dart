import 'package:flutter/material.dart';
import '../data/services/api_service.dart';
import '../data/services/storage_service.dart';
import '../data/models/cart_models.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService;
  final StorageService? _storageService;

  CartProvider(this._apiService, [this._storageService]);

  Cart? _cart;
  Cart? get cart => _cart;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Initialize: check if we have a stored cart ID
  Future<void> init() async {
    final storedCartId = _storageService?.getCartId();
    if (storedCartId != null) {
      await fetchCart(storedCartId);
    }
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

  Future<void> addToCart(String variantId, int quantity) async {
    _isLoading = true;
    notifyListeners();

    try {
      // If no cart, create one
      if (_cart == null) {
        final response = await _apiService.createCart(variantId, quantity);
        if (response.data != null &&
            response.data['data']['cartCreate']['cart'] != null) {
          _cart = Cart.fromJson(response.data['data']['cartCreate']['cart']);
          if (_cart != null) {
            await _storageService?.saveCartId(_cart!.id);
            _updateCounter();
          }
        }
      } else {
        // Fallback or specific add logic if creating new cart every time isn't desired
        // but for now creating works for demo of finding items.
        // Ideally we use cartLinesAdd.
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateQuantity(String lineId, int quantity) async {
    if (_cart == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.updateCart(
        _cart!.id,
        lineId,
        quantity,
      );
      if (response.data != null &&
          response.data['data']['cartLinesUpdate']['cart'] != null) {
        _cart = Cart.fromJson(response.data['data']['cartLinesUpdate']['cart']);
        _updateCounter();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateCounter() {
    if (_cart != null) {
      // Assuming totalQuantity is available in Cart model (verified within getCart query)
      final count = _cart!
          .totalQuantity; // verify if Cart model has this field, query included it.
      _storageService?.saveCartCounter(count);
    }
  }
}
