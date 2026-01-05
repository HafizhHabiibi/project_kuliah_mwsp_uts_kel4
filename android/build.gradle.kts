// Top-level build.gradle.kts

plugins {
    id("com.android.application") apply false
    id("com.android.library") apply false
    id("org.jetbrains.kotlin.android") apply false
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ✅ Tambahkan classpath Google Services untuk Firebase
        classpath("com.google.gms:google-services:4.3.15")
    }
}

// =======================
// Repositori untuk semua subproject
// =======================
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// =======================
// Atur direktori build ke folder luar project
// =======================
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Pastikan app dievaluasi terlebih dahulu
subprojects {
    project.evaluationDependsOn(":app")
}

// =======================
// Clean task
// =======================
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
