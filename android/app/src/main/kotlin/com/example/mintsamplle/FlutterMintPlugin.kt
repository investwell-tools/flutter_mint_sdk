package com.example.mintsamplle

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class FlutterMintPlugin:FlutterPlugin
{
    private var channel: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        setupChannel(binding.binaryMessenger,binding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        teardownChannel()
    }

    private fun setupChannel(messenger: BinaryMessenger, context: Context,) {
        channel = MethodChannel(messenger, "app/mint",)
        val handler = MethodCallHandleImpl(context,)
        channel?.setMethodCallHandler(handler,)
    }

    private fun teardownChannel() {
        channel?.setMethodCallHandler(null,)
        channel = null
    }

}