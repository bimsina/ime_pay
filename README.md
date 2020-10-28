# ImePay plugin for Fluter

Flutter plugin to integrate [ImePay](https://www.imepay.com.np/) in your app.

[![pub package](https://img.shields.io/pub/v/ime_pay.svg)](https://pub.dev/packages/ime_pay)


## How to install

- Add ime_pay in your `pubspec.yaml`

  ```yaml
  dependencies:
    ime_pay: 
  ```  

## Usage

- Create `ImePay` object with the required parameters.

    ```dart
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
    ```
- Call `startPayment` method.

    ```dart
    imePay.startPayment(onSuccess: (ImePaySuccessResponse data) {
            print(data);
        }, onFailure: (error) {
            print(error);
        });
    ```
The response `ImePaySuccessResponse` consists of the following parameters

- `.amount` [String] : the amount paid
- `.refId` [String] : the reference Id of the transaction
- `.msisdn` [String] 
- `.transactionId` [String] 
- `.responseDescription` [String] 
- `.responseCode` [String] 

