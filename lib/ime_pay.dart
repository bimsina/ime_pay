import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ImePay {
  static const MethodChannel _channel = const MethodChannel('ime_pay');

  final String merchantCode,
      merchantName,
      module,
      userName,
      password,
      refId,
      recordingServiceUrl,
      deliveryServiceUrl;

  final double amount;

  final ImePayEnvironment environment;

  ImePay(
      {@required this.merchantCode,
      @required this.merchantName,
      @required this.module,
      @required this.userName,
      @required this.password,
      @required this.refId,
      @required this.recordingServiceUrl,
      @required this.deliveryServiceUrl,
      @required this.amount,
      this.environment = ImePayEnvironment.TEST});

  void startPayment({
    Function(Map) onSuccess,
    Function(String) onFailure,
  }) async {
    _channel.invokeMethod("ime_pay#startPayment", {
      "merchant_code": merchantCode,
      "merchant_name": merchantName,
      "module": module,
      "user_name": userName,
      "password": password,
      "reference_id": refId,
      "amount": amount.toString(),
      "recording_service_url": recordingServiceUrl,
      "delivery_service_url": deliveryServiceUrl,
      "env": environment.toString()
    });
    _listenToPaymentResponse(onSuccess, onFailure);
  }

  _listenToPaymentResponse(Function onSuccess, Function onError) {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "ime_pay#success":
          onSuccess(call.arguments);
          break;
        case "ime_pay#error":
          onError(call.arguments);
          break;
        default:
      }
      return true;
    });
  }
}

enum ImePayEnvironment { TEST, LIVE }
