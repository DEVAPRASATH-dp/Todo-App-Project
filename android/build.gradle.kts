// Top-level Gradle configuration using Kotlin DSL (KTS)

buildscript {
    dependencies {
        // ✅ Firebase Google Services Plugin
        classpath("com.google.gms:google-services:4.4.1")
    }
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    // ✅ Android Gradle Plugin (required for AGP 8+)
    id("com.android.application") version "8.7.3" apply false
    // Removed com.android.library to avoid plugin conflict
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Optional: Custom build output directory for Flutter
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// ✅ Clean build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
