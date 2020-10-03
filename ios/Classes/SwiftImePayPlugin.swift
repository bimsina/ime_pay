import Flutter
import UIKit
import IMEPay

public class SwiftImePayPlugin: NSObject, FlutterPlugin {
    
    public var viewController: UIViewController
    public var channel:FlutterMethodChannel
    
    public init(viewController:UIViewController, channel:FlutterMethodChannel) {
        self.viewController = viewController
        self.channel = channel
    }
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ime_pay", binaryMessenger: registrar.messenger())
        
        let viewController: UIViewController =
        (UIApplication.shared.delegate?.window??.rootViewController)!;
        
        let instance = SwiftImePayPlugin(viewController: viewController, channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
            case "ime_pay#startPayment":
                startPayment(call: call)
                result(true)
                break;
            default:
                break;
        }
    }
    
    func startPayment(call: FlutterMethodCall){
        let message = call.arguments as? Dictionary<String,Any>
        
        
        let merchantCode: String = (message?["merchant_code"] as? String)!;
        let merchantName: String = (message?["merchant_name"] as? String)!;
        let module : String = (message?["module"] as? String)!;
        let user:String = (message?["user_name"] as? String)!;
        let password :String = (message?["password"] as? String)!;
        let refId:String = (message?["reference_id"] as? String)!;
        let amt :String = (message?["amount"] as? String)!;
        let environment:String = (message?["env"] as? String)!;
        let recordingServiceUrl:String = (message?["recording_service_url"] as? String)!;
        //    let deliveryServiceUrl:String = (message?["delivery_service_url"] as? String)!;
        
        let manager :IMPPaymentManager;
        
        if(environment == "LIVE") {
            manager = IMPPaymentManager(environment: Live);
            
        } else {
            manager = IMPPaymentManager(environment: Test);
        }
        
        manager.pay(withUsername: user , password: password, merchantCode: merchantCode, merchantName: merchantName,merchantUrl: recordingServiceUrl, amount: amt, referenceId: refId, module: module, success: { (transactionInfo) in
            
            var response : Dictionary<String,Any> = [:];
            
            response.updateValue(transactionInfo!.responseCode  as Int, forKey: "responseCode")
            response.updateValue(transactionInfo!.responseDescription as String  , forKey: "responseDescription")
            response.updateValue(transactionInfo!.transactionId  as String, forKey: "transactionId")
            response.updateValue(transactionInfo!.customerMsisdn  as String, forKey: "msisdn")
            response.updateValue(transactionInfo!.amount  as String, forKey: "amount")
            response.updateValue(transactionInfo!.referenceId  as String, forKey: "refId")


            self.channel.invokeMethod("ime_pay#success",arguments: response)

            // You can extract the following info from transactionInfo
            //
            //          transactionInfo.responseCode
            //
            //          // Response Code 100:- Transaction successful.
            //          // Response Code 101:- Transaction failed.
            //
            //          transactionInfo.responseDescription // ResponseDescription, message sent from server
            //          transactionInfo.transactionId // Transaction Id, Unique ID generated from IME Pay system.
            //          transctionInfo.customerMsisdn // Customer mobile number (IME Pay wallet ID)
            //          transctionInfo.amount // Payment Amount
            //          transactionInfo.referenceId // Reference Value
            
        }, failure: { (transactionInfo, errorMessage) in
            self.channel.invokeMethod("ime_pay#error", arguments: transactionInfo?.referenceId)
        })
        
        
    }
}
