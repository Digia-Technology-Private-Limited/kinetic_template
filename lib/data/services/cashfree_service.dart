import 'package:dio/dio.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import '../../core/utils/id_generator.dart';

class CashfreeService {
  final Dio _dio;

  // Sandbox credentials - replace with your actual credentials
  static const String _clientId = "TEST430329ae80e0f32e41a393d78b923034";
  static const String _clientSecret =
      "TESTaf195616268bd6202eeb3bf8dc458956e7192a85";
  static const String _baseUrl = "https://sandbox.cashfree.com/pg";

  CashfreeService(this._dio);

  Future<CFSession?> createPaymentSession({
    required double amount,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    String? orderId,
  }) async {
    try {
      final generatedOrderId = orderId ?? IdGenerator.generateOrderId();

      final response = await _dio.post(
        '$_baseUrl/orders',
        options: Options(
          headers: {
            'accept': 'application/json',
            'content-type': 'application/json',
            'x-api-version': '2025-01-01',
            'x-client-id': _clientId,
            'x-client-secret': _clientSecret,
          },
        ),
        data: {
          "order_amount": amount,
          "order_currency": "INR",
          "order_id": generatedOrderId,
          "customer_details": {
            "customer_id": "customer_${DateTime.now().millisecondsSinceEpoch}",
            "customer_name": customerName,
            "customer_email": customerEmail,
            "customer_phone": customerPhone,
          },
          "order_meta": {
            "return_url":
                "https://www.cashfree.com/devstudio/preview/pg/web/checkout?order_id={order_id}",
          },
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final paymentSessionId = data['payment_session_id'];
        final orderId = data['order_id'];

        var cfSession = CFSessionBuilder()
            .setEnvironment(CFEnvironment.SANDBOX)
            .setOrderId(orderId)
            .setPaymentSessionId(paymentSessionId)
            .build();

        return cfSession;
      }
    } catch (e) {
      print('Error creating payment session: $e');
      rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> verifyPayment(String orderId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/orders/$orderId',
        options: Options(
          headers: {
            'accept': 'application/json',
            'x-api-version': '2025-01-01',
            'x-client-id': _clientId,
            'x-client-secret': _clientSecret,
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error verifying payment: $e');
      rethrow;
    }
    return null;
  }
}
