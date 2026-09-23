import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mint_sdk/mint_sdk.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.iw.mint/sdk');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      switch (call.method) {
        case 'generateToken':
          return 'token-123';
        case 'mintLogin':
          throw PlatformException(code: 'INVALID_ARGUMENT', message: 'bad');
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('forwards method name and arguments', () async {
    await MintSdk().invokeMintSdk(sso: 's', token: 't', domain: 'demo');

    expect(calls.single.method, 'invokeMintSDKForFlutter');
    expect(calls.single.arguments, {'sso': 's', 'token': 't', 'domain': 'demo'});
  });

  test('returns native results', () async {
    expect(await MintSdk().generateToken(), 'token-123');
  });

  test('wraps PlatformException in MintSdkException', () async {
    expect(
      MintSdk().mintLogin(domain: 'demo', fcmToken: 'x'),
      throwsA(isA<MintSdkException>()),
    );
  });
}
