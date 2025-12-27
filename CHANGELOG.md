## 0.4.1

### Dependencies
- Updated Flutter SDK constraint to `>=3.38.0` for compatibility with latest Flutter versions

## 0.4.0

### Architecture & Code Refactoring
- Implemented platform interface pattern for better testability and maintainability
- Added `BeaconBroadcastPlatformInterface` for abstract platform implementation
- Added `BeaconBroadcastMethodChannel` for method channel communication
- Refactored main plugin file to use platform interface pattern
- Enhanced test coverage with improved mock platform implementation

### iOS Improvements
- Refactored iOS implementation to use Swift Package Manager structure
- Added Swift Package support with new `Package.swift` configuration
- Reorganized iOS source files into proper Swift Package structure
- Updated podspec to use new source file structure
- Set minimum iOS deployment target to 12.0
- Updated Swift version to 5.9 in podspec
- Enhanced podspec with improved summary and description
- Removed obsolete header files and Objective-C bridge code
- Improved Flutter integration with `FlutterGeneratedPluginSwiftPackage`

### iOS Configuration Updates
- Updated minimum iOS version to 13.0 in project settings
- Refactored Podfile for improved Flutter integration
- Added SceneDelegate for multi-scene support
- Enhanced AppDelegate for Swift 5 compatibility
- Added Bluetooth usage descriptions in Info.plist
- Updated Xcode project settings for Xcode 15 compatibility
- Added pre-action script for Flutter framework preparation in Xcode scheme
- Removed obsolete Podfile.lock from version control

### macOS Support
- Added Podfile for macOS platform support
- Added generated plugin registrant files for macOS
- Added Flutter ephemeral configuration for macOS

### Linux Support
- Added generated plugin registrant files for Linux platform
- Added CMake configuration for Linux Flutter integration

### Build & Configuration
- Comprehensive `.gitignore` update to exclude generated files and build artifacts
- Added patterns for iOS ephemeral files, generated plugin registrants, and platform-specific build outputs
- Removed obsolete generated files from version control
- Added `analysis_options.yaml` for Dart and Flutter linting in example app
- Updated `.metadata` files for project structure

### Example App Improvements
- Added Android dark theme support with `values-night/styles.xml`
- Added Android launch background drawable for API 21+
- Added iOS test target with `RunnerTests.swift`
- Updated example app to use new plugin API

### Dependencies
- Updated plugin metadata in `pubspec.yaml`
- Maintained compatibility with Flutter >=3.0.0 and Dart SDK >=3.10.0 <4.0.0

## 0.3.3

### Build & Configuration
- Migrated Android configuration to Kotlin DSL
- Updated Gradle to version 8.4
- Updated Kotlin in Android configuration
- Added `analysis_options.yaml` for Dart and Flutter linting
- Updated SDK constraints (>=3.10.0 <4.0.0) and Flutter (>=3.0.0)

### Permissions
- Added required Bluetooth permissions for beacon broadcasting on Android 12 and above

### Code Improvements
- Improved error handling in Android configuration
- Improved UUID validation in Swift code
- Refactored Swift code for better robustness

### Dependencies & Metadata
- Added MIT license in `pubspec.yaml`
- Added repository and issue tracker metadata in `pubspec.yaml`
- Updated test dependency to `^1.26.0`
- Updated `flutter_lints` to `^5.0.0`

## 0.3.1

Added support for Android apps targeting SDK 31 and above

## 0.3.0

Added support for null safety
Added support for nullable identifiers (e.g. for the Eddystone layout)

## 0.2.3

Fixed data fields support on Android

## 0.2.2

Added support for setting data fields on Android
Added support for setting advertisement mode on Android

## 0.2.1

Updated the documentation

## 0.2.0

Added option to set manufacturer and layout for Android. 


## 0.1.2

Updates in the documentation


## 0.1.1

Added method for checking if transmission is supported on the device.


## 0.1.0

First stable version of the app. No major changes


## 0.0.1

Initial version of the library. This version includes:
* starting and stopping beacon advertising
* setting beacon UUID, major id, minor id, transmission power and identifier 
