import 'package:flutter/material.dart';
import '../data/services/storage_service.dart';

class WishlistProvider with ChangeNotifier {
  final StorageService _storageService;
  Set<String> _likedProductIds = {};

  WishlistProvider(this._storageService) {
    _loadWishlist();
  }

  Set<String> get likedProductIds => _likedProductIds;

  bool isLiked(String productId) {
    return _likedProductIds.contains(productId);
  }

  Future<void> _loadWishlist() async {
    _likedProductIds = _storageService.getWishlist().toSet();
    notifyListeners();
  }

  Future<void> toggleLike(String productId) async {
    if (_likedProductIds.contains(productId)) {
      _likedProductIds.remove(productId);
    } else {
      _likedProductIds.add(productId);
    }
    await _storageService.saveWishlist(_likedProductIds.toList());
    notifyListeners();
  }

  Future<void> addToWishlist(String productId) async {
    if (!_likedProductIds.contains(productId)) {
      _likedProductIds.add(productId);
      await _storageService.saveWishlist(_likedProductIds.toList());
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    if (_likedProductIds.contains(productId)) {
      _likedProductIds.remove(productId);
      await _storageService.saveWishlist(_likedProductIds.toList());
      notifyListeners();
    }
  }

  int get itemCount => _likedProductIds.length;
}
