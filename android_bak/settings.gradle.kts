// settings.gradle.kts  — Kotlin DSL

pluginManagement {
    // Flutter toolchain
    val properties = java.util.Properties()
    file("local.properties").inputStream().use { properties.load(it) }
    val flutterSdkPath = properties.getProperty("flutter.sdk")
            ?: error("flutter.sdk not set in local.properties")
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"

    // Android Gradle Plugin + Kotlin (Flutter stable ile uyumlu kombinasyon)
    id("com.android.application") version "8.5.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false

    // Google Services (Kotlin DSL: version(...) ya da version "..." fark etmez)
    id("com.google.gms.google-services") version "4.4.2" apply false
}

include(":app")