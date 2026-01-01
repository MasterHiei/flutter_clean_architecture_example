plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_clean_architecture_example"
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_21.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_clean_architecture_example"
        minSdk = 26
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    flavorDimensions += "default"

    productFlavors {
        create("dev") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "(DEV)Flutter Clean Architecture Example")
            applicationIdSuffix = ".dev"
            versionNameSuffix = ".dev"
        }
        create("prod") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "Flutter Clean Architecture Example")
        }
    }
}

flutter {
    source = "../.."
}
