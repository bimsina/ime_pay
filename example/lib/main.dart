import 'package:flutter/material.dart';
import 'package:ime_pay/ime_pay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IME PAY example app'),
        ),
        body: Center(
          child: ElevatedButton(
              child: Text('Pay with IME'),
              onPressed: () {
                ImePay imePay = ImePay(
                  merchantCode: 'TEST',
                  module: 'TEST',
                  userName: 'TEST',
                  password: 'TEST',
                  amount: 50.0,
                  merchantName: 'TEST',
                  recordingServiceUrl: 'TEST',
                  deliveryServiceUrl: 'TEST',
                  environment: ImePayEnvironment.TEST,
                  refId: 'TEST',
                );
                imePay.startPayment(onSuccess: (ImePaySuccessResponse data) {
                  print(data);
                }, onFailure: (error) {
                  print(error);
                });
              }),
        ),
      ),
    );
  }
}
