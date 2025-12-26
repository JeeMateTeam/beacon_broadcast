pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("com.android.library") version "8.3.1" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
}

rootProject.name = "beacon_broadcast"

