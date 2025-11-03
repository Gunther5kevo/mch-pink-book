plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.mch.pink_book"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.mch.pink_book"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"
    }

    signingConfigs {
        getByName("debug") {
            // Optional: configure your debug keystore if needed
            // storeFile = file("debug.keystore")
            // storePassword = "android"
            // keyAlias = "androiddebugkey"
            // keyPassword = "android"
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:2.1.0")
}

/**
 * Copies generated APKs from the Android build directory
 * to Flutter's default output path for convenience.
 */
afterEvaluate {
    tasks.named("assembleDebug") {
        doLast {
            copyApkToFlutterDir("debug")
        }
    }

    tasks.named("assembleRelease") {
        doLast {
            copyApkToFlutterDir("release")
        }
    }
}

fun copyApkToFlutterDir(buildType: String) {
    val sourceFile = file("build/outputs/apk/$buildType/app-$buildType.apk")
    val destDir = rootDir.resolve("../build/app/outputs/flutter-apk").apply { mkdirs() }

    if (sourceFile.exists()) {
        val destFile = destDir.resolve("app-$buildType.apk")
        sourceFile.copyTo(destFile, overwrite = true)
        println("✅ Copied app-$buildType.apk to Flutter build folder: $destDir")
    } else {
        println("⚠️ APK not found at: ${sourceFile.absolutePath}")
    }
}
