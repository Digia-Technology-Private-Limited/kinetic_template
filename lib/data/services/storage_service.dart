import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyCartId = 'cart_id';
  static const String _keyCartCounter = 'cart_counter';
  static const String _keyGender = 'gender';
  static const String _keyAvatar = 'user_avatar';

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
}
