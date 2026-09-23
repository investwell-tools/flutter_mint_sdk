import 'dart:convert';

import 'package:http/http.dart' as http;

/// Ports the two-step SSO token exchange from the native demo's
/// `MainActivity.generateAuth()` / `getAuthenticationKey()`
/// (demo/src/main/java/com/iw/mint/demo/MainActivity.kt).
class SsoAuthService {
  static const _base = 'https://demo.investwell.app/api/aggregator/auth';

  Future<String> fetchSsoToken() async {
    final authToken = await _post(
      '$_base/getAuthorizationToken',
      {'authName': 'demoapi', 'password': 'Mint@1001'},
      resultKey: 'token',
    );

    return _post(
      '$_base/getAuthenticationKey',
      {'token': authToken, 'username': 'demo'},
      resultKey: 'SSOToken',
    );
  }

  Future<String> _post(
    String url,
    Map<String, dynamic> body, {
    required String resultKey,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['status'] != 0) {
      throw Exception(json['message'] ?? 'SSO request failed ($url)');
    }

    final result = json['result'] as Map<String, dynamic>?;
    final value = result?[resultKey] as String?;
    if (value == null || value.isEmpty) {
      throw Exception('SSO response missing "$resultKey" ($url)');
    }
    return value;
  }
}
