import 'package:flutter/material.dart';

import 'package:mint_sdk/mint_sdk.dart';
import '../services/sso_auth_service.dart';

/// Flutter counterpart of the native demo's MainActivity
/// (demo/src/main/java/com/iw/mint/demo/MainActivity.kt) — same domain,
/// same custom app key, same five actions and testing-mode switch.
class MintDemoScreen extends StatefulWidget {
  const MintDemoScreen({super.key});

  @override
  State<MintDemoScreen> createState() => _MintDemoScreenState();
}

class _MintDemoScreenState extends State<MintDemoScreen> {
  static const _domain = 'demo';
  static const _customApiKey = 'IWCustom_@mint';

  final _mintSdk = MintSdk();
  final _ssoAuthService = SsoAuthService();

  bool _testingMode = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _mintSdk.configureSdk(isConfigured: true).catchError((_) {});
    _mintSdk.setIsProduction(false).catchError((_) {});
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await _mintSdk.setTestingMode(_testingMode);
      await action();
    } on MintSdkException catch (e) {
      _showMessage(e.message ?? 'Mint SDK error');
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openLogin() => _run(() async {
        final fcmToken = await _mintSdk.generateToken();
        await _mintSdk.mintLogin(domain: _domain, fcmToken: fcmToken);
      });

  Future<void> _createAccount() => _run(() async {
        final fcmToken = await _mintSdk.generateToken();
        await _mintSdk.createAccount(domain: _domain, fcmToken: fcmToken);
      });

  Future<void> _invokeWithSso() => _run(() async {
        final ssoToken = await _ssoAuthService.fetchSsoToken();
        final token = await _mintSdk.generateToken();
        await _mintSdk.invokeMintSdk(
          sso: ssoToken,
          token: token,
          domain: _domain,
        );
      });

  Future<void> _buildMintScreen() => _run(() async {
        final fcmToken = await _mintSdk.generateToken();
        await _mintSdk.buildMintScreen(
          domain: _domain,
          fcmToken: fcmToken,
          customAppKey: _customApiKey,
        );
      });

  Future<void> _clearSdkData() => _run(() async {
        await _mintSdk.clearSdkData();
        _showMessage('SDK data clear requested');
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mint SDK Demo')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mint SDK Demo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                'Use this app to exercise the Mint SDK from the local '
                ':app library.',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Testing mode'),
                value: _testingMode,
                onChanged: _busy
                    ? null
                    : (value) => setState(() => _testingMode = value),
              ),
              const SizedBox(height: 8),
              _actionButton('Open Login', _openLogin),
              _actionButton('Create Account', _createAccount),
              _actionButton('Invoke SDK With SSO', _invokeWithSso),
              _actionButton('Build Mint Screen', _buildMintScreen),
              _actionButton('Clear SDK Data', _clearSdkData),
              if (_busy) ...[
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String label, Future<void> Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: _busy ? null : onPressed,
          child: Text(label),
        ),
      ),
    );
  }
}
