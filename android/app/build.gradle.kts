import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Upload key. key.properties is never committed (see android/.gitignore);
// without it, release builds fall back to the debug key so `flutter run --release` still works.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "com.chauvb.nonogram"
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
        // Do not change: the application ID is permanent once registered on Firebase / Google Play.
        applicationId = "com.chauvb.nonogram"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Flavor: `dev` (bản thử nội bộ, mặc định trên GitHub Actions: có màn chọn chế
    // độ chơi và bộ màn của chế độ nhà phát triển) và `store` (bản phát hành).
    // Cùng applicationId: không đổi được vì đã đăng ký trên Firebase / Google Play.
    // Build luôn kèm --flavor, vd. `flutter run --flavor dev`.
    flavorDimensions += "track"
    productFlavors {
        // AdMob App ID: bản dev dùng App ID thử nghiệm của Google, bản store
        // dùng App ID thật của Nonopix (ID đơn vị quảng cáo: lib/ads/ad_config.dart).
        create("dev") {
            dimension = "track"
            manifestPlaceholders["admobAppId"] = "ca-app-pub-3940256099942544~3347511713"
        }
        create("store") {
            dimension = "track"
            manifestPlaceholders["admobAppId"] = "ca-app-pub-8391885617554349~5283904151"
        }
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig =
                if (keystorePropertiesFile.exists()) {
                    signingConfigs.getByName("release")
                } else {
                    signingConfigs.getByName("debug")
                }
        }
    }
}

flutter {
    source = "../.."
}
