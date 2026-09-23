plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.iw.mint.flutter_demo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.iw.mint.flutter_demo"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // mint-sdk's manifest declares minSdkVersion 25 (see demo/build.gradle.kts
        // at the repo root, which the native demo module also raises to 25).
        minSdk = maxOf(flutter.minSdkVersion, 25)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
    buildFeatures {
        dataBinding = true
        buildConfig = true
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Needed for Demo (extends the SDK's AppApplication); the mint_sdk plugin
    // brings the same artifact in from its bundled repo.
    implementation("com.investwell.tools:mint-sdk:7.6.11")
}
