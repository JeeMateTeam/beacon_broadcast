## 0.3.3

### Configuration et build
- Migration de la configuration Android vers Kotlin DSL
- Mise à jour de Gradle vers la version 8.4
- Mise à jour de Kotlin dans la configuration Android
- Ajout de `analysis_options.yaml` pour le linting Dart et Flutter
- Mise à jour des contraintes SDK (>=3.10.0 <4.0.0) et Flutter (>=3.0.0)

### Permissions
- Ajout des permissions Bluetooth nécessaires pour la diffusion de beacon sur Android 12 et versions supérieures

### Améliorations du code
- Amélioration de la gestion d'erreurs dans la configuration Android
- Amélioration de la validation des UUID dans le code Swift
- Refactorisation du code Swift pour une meilleure robustesse

### Dépendances et métadonnées
- Ajout de la licence MIT dans `pubspec.yaml`
- Ajout des métadonnées de repository et issue tracker dans `pubspec.yaml`
- Mise à jour de la dépendance de test vers `^1.26.0`
- Mise à jour de `flutter_lints` vers `^5.0.0`

## 0.3.1

Added support for android apps targetting SDK 31 and above

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
