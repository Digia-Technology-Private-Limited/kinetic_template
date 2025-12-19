import 'package:uuid/uuid.dart';

class IdGenerator {
  static const _uuid = Uuid();

  /// Generate a unique ID using UUID v4
  static String generateId() {
    return _uuid.v4();
  }

  /// Generate a unique order ID with a prefix
  static String generateOrderId() {
    return 'ORD-${_uuid.v4().substring(0, 8).toUpperCase()}';
  }

  /// Generate a unique cart ID with a prefix
  static String generateCartId() {
    return 'CART-${_uuid.v4().substring(0, 12)}';
  }

  /// Generate a unique session ID
  static String generateSessionId() {
    return 'SESSION-${_uuid.v4()}';
  }

  /// Generate a unique transaction ID
  static String generateTransactionId() {
    return 'TXN-${_uuid.v4().substring(0, 10).toUpperCase()}';
  }

  /// Generate a timestamp-based ID for better sorting
  static String generateTimeBasedId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uniquePart = _uuid.v4().substring(0, 8);
    return '$timestamp-$uniquePart';
  }
}

