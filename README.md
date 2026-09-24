# mint_sdk

Flutter plugin wrapping the Investwell Mint Android SDK
(`com.investwell.tools:mint-sdk:7.6.11`). Android only.

The native AAR ships inside this package (`repo/`), so consumer apps need no
extra Maven repository setup.

## Installation

The package is distributed as a git dependency pinned to a release tag:

```yaml
dependencies:
  mint_sdk:
    git:
      url: https://github.com/investwell-tools/flutter_mint_sdk.git
      ref: v1.0.0
```

## Android setup

- `minSdk` must be 25 or higher.
- The SDK expects the app's `Application` class to extend
  `investwell.activity.AppApplication`. Add the SDK dependency to
  `android/app/build.gradle.kts` so the class is visible to your app module:

  ```kotlin
  dependencies {
      implementation("com.investwell.tools:mint-sdk:7.6.11")
  }
  ```

  ```kotlin
  class MyApplication : investwell.activity.AppApplication()
  ```

  and register it in `AndroidManifest.xml` with
  `<application android:name=".MyApplication" ...>`.

## Usage

```dart
import 'package:mint_sdk/mint_sdk.dart';

final mintSdk = MintSdk();

try {
  await mintSdk.setIsProduction(false);
  await mintSdk.invokeMintSdk(sso: sso, token: token, domain: 'demo');
} on MintSdkException catch (e) {
  // Invalid arguments or an SDK-side failure.
}
```

Available methods: `configureSdk`, `isSdkConfigured`, `setIsProduction`,
`setTestingMode`, `clearSdkData`, `mintLogin`, `createAccount`,
`buildMintScreen`, `invokeMintSdk` and `generateToken`.

See [`example/`](example) for a complete app, including fetching the SSO
token.

## Releasing

Bump `version` in `pubspec.yaml`, update `CHANGELOG.md`, then push a matching
tag (`git tag v1.0.1 && git push origin v1.0.1`). The release workflow checks
the tag against the pubspec version, analyzes, tests, builds the example APK,
and publishes a GitHub Release.
