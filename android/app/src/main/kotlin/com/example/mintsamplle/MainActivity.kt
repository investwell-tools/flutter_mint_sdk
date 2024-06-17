package com.example.mintsamplle

import android.content.Intent
import android.os.Build
import android.os.Bundle
import investwell.activity.SplashActivity
import investwell.sdk.MintSDK
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONException
import org.json.JSONObject
import java.lang.Exception

class MainActivity: FlutterActivity() {

    private val CHANNEL = "mint-android-app"

    override fun onCreate(savedInstanceState: Bundle?) {
        // Aligns the Flutter view vertically with the window.
//        WindowCompat.setDecorFitsSystemWindows(getWindow(), false)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
        }

        super.onCreate(savedInstanceState)

        // mintSDK Invoke

        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
        flutterEngine?.dartExecutor?.binaryMessenger?.let {  MethodChannel(it,CHANNEL).setMethodCallHandler { call, result ->

            if (call.method == "openMintLib") {
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
                            }catch (e:Exception){e.printStackTrace()}
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
            } else {
                result.notImplemented()
            }
        } }

    }

    private fun invokeSDK(sso: String,fcmToken:String,domain:String,classWithPackage:String= "${this@MainActivity.packageName}.MainActivity") {
        val mintSdk = MintSDK(this@MainActivity)
        mintSdk.invokeMintSDK(sso,fcmToken,domain,classWithPackage)
    }

}


