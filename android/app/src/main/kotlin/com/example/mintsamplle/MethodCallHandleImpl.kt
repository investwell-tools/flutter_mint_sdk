package com.example.mintsamplle

import android.content.Context
import investwell.sdk.MintSDK
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.json.JSONException
import org.json.JSONObject
import java.lang.Exception

internal class MethodCallHandleImpl(private var context: Context):MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method){
            "openMintLib"->{
                try {
                    var domain =""
                    var sso =""
                    var fcm =""
                    val argumentsString: String? = call.arguments?.toString()
                    val tokenResponse = JSONObject(call.arguments.toString())
                    if (tokenResponse.toString().isEmpty()){
                        argumentsString.let { jsonString->
                            try {
                                val newResponse = JSONObject(jsonString)
                                domain = newResponse.optString("domain")
                                sso = newResponse.optString("ssoToken")
                                fcm = newResponse.optString("fcmToken")
                            }catch (e: Exception){e.printStackTrace()}
                        }
                    }else{
                        domain = tokenResponse.optString("domain")
                        sso = tokenResponse.optString("ssoToken")
                        fcm = tokenResponse.optString("fcmToken")
                    }
                    invokeSDK(sso,fcm,domain)
                    result.success("Success")
                }catch (e: JSONException) {
                    // Handle JSON parsing error
                    result.error("JSON Parsing Error", e.message, null)
                }
            }
            else -> result.notImplemented()

        }
    }

    private fun invokeSDK(sso: String,fcmToken:String,domain:String,classWithPackage:String= "${context.packageName}.MainActivity") {
        val mintSdk = MintSDK(context)
        mintSdk.invokeMintSDK(sso,fcmToken,domain,classWithPackage)
    }

}