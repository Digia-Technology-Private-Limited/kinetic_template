import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/id_generator.dart';

class StorageService {
  static const String _keyCartId = 'cart_id';
  static const String _keyCartCounter = 'cart_counter';
  static const String _keyGender = 'gender';
  static const String _keyAvatar = 'user_avatar';
  static const String _keySessionId = 'session_id';
  static const String _keyWishlist = 'wishlist';
  static const String _keyCart = 'local_cart';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Cart ID
  Future<void> saveCartId(String cartId) async {
    await _prefs.setString(_keyCartId, cartId);
  }

  String? getCartId() {
    return _prefs.getString(_keyCartId);
  }

  // Cart Counter
  Future<void> saveCartCounter(int count) async {
    await _prefs.setInt(_keyCartCounter, count);
  }

  int getCartCounter() {
    return _prefs.getInt(_keyCartCounter) ?? 0;
  }

  // Gender
  Future<void> saveGender(String gender) async {
    await _prefs.setString(_keyGender, gender);
  }

  String? getGender() {
    return _prefs.getString(_keyGender);
  }

  // Home Page Config (Avatar)
  Future<void> saveAvatar(String url) async {
    await _prefs.setString(_keyAvatar, url);
  }

  String? getAvatar() {
    return _prefs.getString(_keyAvatar);
  }

  // Session ID
  Future<void> saveSessionId(String sessionId) async {
    await _prefs.setString(_keySessionId, sessionId);
  }

  String getSessionId() {
    String? sessionId = _prefs.getString(_keySessionId);
    if (sessionId == null) {
      // Generate new session ID if not exists
      sessionId = IdGenerator.generateSessionId();
      saveSessionId(sessionId);
    }
    return sessionId;
  }

  // Wishlist
  Future<void> saveWishlist(List<String> productIds) async {
    await _prefs.setString(_keyWishlist, productIds.join(','));
  }

  List<String> getWishlist() {
    final wishlistStr = _prefs.getString(_keyWishlist);
    if (wishlistStr == null || wishlistStr.isEmpty) return [];
    return wishlistStr.split(',');
  }

  // Local Cart
  Future<void> saveLocalCart(String cartJson) async {
    await _prefs.setString(_keyCart, cartJson);
  }

  String? getLocalCart() {
    return _prefs.getString(_keyCart);
  }

  Future<void> clearLocalCart() async {
    await _prefs.remove(_keyCart);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
