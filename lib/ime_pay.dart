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
      {required this.merchantCode,
      required this.merchantName,
      required this.module,
      required this.userName,
      required this.password,
      required this.refId,
      required this.recordingServiceUrl,
      required this.deliveryServiceUrl,
      required this.amount,
      this.environment = ImePayEnvironment.TEST});

  void startPayment({
    Function(ImePaySuccessResponse)? onSuccess,
    Function(String?)? onFailure,
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
      "env": environment.toString().split('.').last
    });
    _listenToPaymentResponse(onSuccess, onFailure);
  }

  _listenToPaymentResponse(
      Function(ImePaySuccessResponse)? onSuccess, Function(String?)? onError) {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "ime_pay#success":
          Map<String, dynamic> responseMap = Map.from(call.arguments);
          ImePaySuccessResponse response = ImePaySuccessResponse(
              amount: responseMap["amount"],
              msisdn: responseMap["msisdn"],
              refId: responseMap["refId"],
              responseCode: responseMap["responseCode"],
              responseDescription: responseMap["responseDescription"],
              transactionId: responseMap["transactionId"]);
          onSuccess!(response);
          break;
        case "ime_pay#error":
          onError!(call.arguments);
          break;
        default:
      }
      return true;
    });
  }
}

enum ImePayEnvironment { TEST, LIVE }

class ImePaySuccessResponse {
  final String? responseCode,
      responseDescription,
      transactionId,
      msisdn,
      amount,
      refId;

  ImePaySuccessResponse(
      {this.responseCode,
      this.responseDescription,
      this.transactionId,
      this.msisdn,
      this.amount,
      this.refId});
}
