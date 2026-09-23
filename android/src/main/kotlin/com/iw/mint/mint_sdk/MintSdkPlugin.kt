package com.iw.mint.mint_sdk

import android.app.Activity
import investwell.mintSdk.MintSDK
import investwell.mintSdk.MintSdkThemeMode
import investwell.mintSdk.TokenGenerator
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Hosts the Mint SDK behind the `com.iw.mint/sdk` MethodChannel so the Dart
 * `MintSdk` wrapper can drive it. The SDK is bound to the host activity.
 */
class MintSdkPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var mintSdk: MintSDK? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.iw.mint/sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        mintSdk = null
    }

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) =
        onAttachedToActivity(binding)

    override fun onDetachedFromActivity() {
        activity = null
        mintSdk = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val host = activity
        if (host == null) {
            result.error("NO_ACTIVITY", "Mint SDK requires a foreground activity", null)
            return
        }
        val sdk = mintSdk ?: MintSDK(host, MintSdkThemeMode.LIGHT).also { mintSdk = it }

        try {
            when (call.method) {
                "configureSDK" -> {
                    val isConfigured = call.argument<Boolean>("isConfigured") ?: true
                    val customLoader = call.argument<Int>("customLoader")
                    sdk.configureSDK(isConfigured, customLoader)
                    result.success(null)
                }

                "isSdkConfigured" -> result.success(sdk.isSdkConfigured())

                "setIsProduction" -> {
                    val isProd = call.argument<Boolean>("isProd") ?: false
                    sdk.setIsProduction(isProd)
                    result.success(null)
                }

                "setTestingMode" -> {
                    val isTestMode = call.argument<Boolean>("isTestMode") ?: false
                    sdk.setTestingMode(isTestMode)
                    result.success(null)
                }

                "clearSDKData" -> {
                    sdk.clearSDKData()
                    result.success(null)
                }

                "mintLogin" -> {
                    val domain = requireArg(call, "domain", result) ?: return
                    val fcmToken = requireArg(call, "fcmToken", result) ?: return
                    sdk.mintLogin(domain, fcmToken)
                    result.success(null)
                }

                "createAccount" -> {
                    val domain = requireArg(call, "domain", result) ?: return
                    val fcmToken = call.argument<String>("fcmToken") ?: ""
                    sdk.createAccount(domain, fcmToken)
                    result.success(null)
                }

                "buildMintScreen" -> {
                    val domain = requireArg(call, "domain", result) ?: return
                    val fcmToken = requireArg(call, "fcmToken", result) ?: return
                    val customAppKey = requireArg(call, "customAppKey", result) ?: return
                    val customLoader = call.argument<Int>("customLoader")
                    val isSignUp = call.argument<Boolean>("isSignUp") ?: false
                    sdk.buildMintScreen(
                        domain = domain,
                        fcmToken = fcmToken,
                        customAppKey = customAppKey,
                        customLoader = customLoader,
                        isSignUp = isSignUp,
                        callFromCurrentClassPackage = host.javaClass.name,
                    )
                    result.success(null)
                }

                "invokeMintSDKForFlutter" -> {
                    val sso = requireArg(call, "sso", result) ?: return
                    val token = requireArg(call, "token", result) ?: return
                    val domain = requireArg(call, "domain", result) ?: return
                    sdk.invokeMintSDKForFlutter(sso = sso, token = token, domain = domain)
                    result.success(null)
                }

                "generateToken" -> result.success(TokenGenerator.generate())

                else -> result.notImplemented()
            }
        } catch (exception: IllegalArgumentException) {
            result.error("INVALID_ARGUMENT", exception.message, null)
        } catch (exception: Exception) {
            result.error("MINT_SDK_ERROR", exception.message, null)
        }
    }

    private fun requireArg(call: MethodCall, name: String, result: Result): String? {
        val value = call.argument<String>(name)
        if (value.isNullOrBlank()) {
            result.error("INVALID_ARGUMENT", "$name is required", null)
            return null
        }
        return value
    }
}
