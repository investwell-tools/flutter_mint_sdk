import 'package:flutter/services.dart';

/// Mirrors `investwell.mintSdk.MintSdkThemeMode` on the native side.
enum MintSdkThemeMode { system, light, dark }

/// Thrown when the native Mint SDK rejects a call (blank/invalid arguments,
/// SDK not configured, etc). Wraps the underlying [PlatformException].
class MintSdkException implements Exception {
  MintSdkException(this.message);

  final String? message;

  @override
  String toString() => message ?? 'Mint SDK error';
}

/// Dart wrapper around the native `investwell.mintSdk.MintSDK` class,
/// reached through the `com.iw.mint/sdk` MethodChannel registered by
/// `MintSdkPlugin` on Android.
class MintSdk {
  MintSdk({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('com.iw.mint/sdk');

  final MethodChannel _channel;

  Future<T> _invoke<T>(String method, [Map<String, dynamic>? args]) async {
    try {
      final result = await _channel.invokeMethod<T>(method, args);
      return result as T;
    } on PlatformException catch (e) {
      throw MintSdkException(e.message);
    }
  }

  Future<void> configureSdk({required bool isConfigured, int? customLoader}) {
    return _invoke<void>('configureSDK', {
      'isConfigured': isConfigured,
      'customLoader': customLoader,
    });
  }

  Future<bool> isSdkConfigured() => _invoke<bool>('isSdkConfigured');

  Future<void> setIsProduction(bool isProd) {
    return _invoke<void>('setIsProduction', {'isProd': isProd});
  }

  Future<void> setTestingMode(bool isTestMode) {
    return _invoke<void>('setTestingMode', {'isTestMode': isTestMode});
  }

  Future<void> clearSdkData() => _invoke<void>('clearSDKData');

  Future<void> mintLogin({required String domain, required String fcmToken}) {
    return _invoke<void>('mintLogin', {
      'domain': domain,
      'fcmToken': fcmToken,
    });
  }

  Future<void> createAccount({required String domain, String? fcmToken}) {
    return _invoke<void>('createAccount', {
      'domain': domain,
      'fcmToken': fcmToken ?? '',
    });
  }

  Future<void> buildMintScreen({
    required String domain,
    required String fcmToken,
    required String customAppKey,
    int? customLoader,
    bool isSignUp = false,
  }) {
    return _invoke<void>('buildMintScreen', {
      'domain': domain,
      'fcmToken': fcmToken,
      'customAppKey': customAppKey,
      'customLoader': customLoader,
      'isSignUp': isSignUp,
    });
  }

  /// Uses the SDK's Flutter-specific entry point (`invokeMintSDKForFlutter`),
  /// which does not require a `classWithPackage` string.
  Future<void> invokeMintSdk({
    required String sso,
    required String token,
    required String domain,
  }) {
    return _invoke<void>('invokeMintSDKForFlutter', {
      'sso': sso,
      'token': token,
      'domain': domain,
    });
  }

  Future<String> generateToken() => _invoke<String>('generateToken');
}
