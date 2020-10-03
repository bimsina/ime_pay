package com.bimsina.ime_pay

import android.app.Activity
import androidx.annotation.NonNull
import com.swifttechnology.imepaysdk.ENVIRONMENT
import com.swifttechnology.imepaysdk.IMEPayment
import com.swifttechnology.imepaysdk.IMEPaymentCallback
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/** ImePayPlugin */
class ImePayPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "ime_pay")
        channel.setMethodCallHandler(this)
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "ime_pay")
            channel.setMethodCallHandler(ImePayPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "ime_pay#startPayment" -> {
                startPayment(call)
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }


    private fun startPayment(call: MethodCall) {
        val message = call.arguments as HashMap<*, *>
        val merchantCode: String = message["merchant_code"] as String
        val merchantName: String = message["merchant_name"] as String
        val module = message["module"] as String
        val user = message["user_name"] as String
        val password = message["password"] as String
        val refId = message["reference_id"] as String
        val amount = message["amount"] as String
        val env: String = message["env"] as String
        val recordingServiceUrl = message["recording_service_url"] as String
        val deliveryServiceUrl = message["delivery_service_url"] as String


        val imePayment: IMEPayment

        imePayment = if (env == "LIVE") IMEPayment(activity, ENVIRONMENT.LIVE) else IMEPayment(activity, ENVIRONMENT.TEST)


        imePayment.performPaymentV1(merchantCode,
                merchantName,
                recordingServiceUrl,
                deliveryServiceUrl,
                amount,
                refId,
                module,
                user,
                password,
                object : IMEPaymentCallback {
                    override fun onSuccess(responseCode: Int, responseDescription: String?, transactionId: String?, msisdn: String?, amount: String?, refId: String?) {
                        val response: HashMap<String, String> = HashMap()
                        response["responseCode"] = responseCode.toString()
                        response["responseDescription"] = responseDescription.toString()
                        response["transactionId"] = transactionId.toString()
                        response["msisdn"] = msisdn.toString()
                        response["amount"]= amount.toString()
                        response["refId"] = refId.toString()

                        channel.invokeMethod("ime_pay#success", response)
                    }

                    override fun onTransactionCancelled(refId: String?) {
                        channel.invokeMethod("ime_pay#error", refId)
                    }
                }
        )

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }
}
