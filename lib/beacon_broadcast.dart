// Copyright (c) <2019> <Paulina Szklarska>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:async';

import 'package:flutter/services.dart';

/// A Flutter plugin for turning your device into a beacon.
///
/// This plugin uses AltBeacon library for Android and CoreLocation for iOS.
/// It provides a builder pattern API for configuring and controlling beacon
/// advertising.
///
/// Example:
/// ```dart
/// final beaconBroadcast = BeaconBroadcast()
///   .setUUID('39ED98FF-2900-441A-802F-9C398FC199D2')
///   .setMajorId(1)
///   .setMinorId(100)
///   .start();
/// ```
class BeaconBroadcast {
  /// AltBeacon layout identifier for Android.
  static const String altbeaconLayout =
      'm:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25';

  /// Eddystone TLM layout identifier for Android.
  static const String eddystoneTlmLayout =
      'x,s:0-1=feaa,m:2-2=20,d:3-3,d:4-5,d:6-7,d:8-11,d:12-15';

  /// Eddystone UID layout identifier for Android.
  static const String eddystoneUidLayout =
      's:0-1=feaa,m:2-2=00,p:3-3:-41,i:4-13,i:14-19';

  /// Eddystone URL layout identifier for Android.
  static const String eddystoneUrlLayout =
      's:0-1=feaa,m:2-2=10,p:3-3:-41,i:4-21v';

  /// URI Beacon layout identifier for Android.
  static const String uriBeaconLayout = 's:0-1=fed8,m:2-2=00,p:3-3:-41,i:4-21v';

  // Deprecated constants for backward compatibility
  /// @deprecated Use [altbeaconLayout] instead.
  // ignore: constant_identifier_names
  @Deprecated('Use altbeaconLayout instead')
  static const String ALTBEACON_LAYOUT = altbeaconLayout;

  /// @deprecated Use [eddystoneTlmLayout] instead.
  // ignore: constant_identifier_names
  @Deprecated('Use eddystoneTlmLayout instead')
  static const String EDDYSTONE_TLM_LAYOUT = eddystoneTlmLayout;

  /// @deprecated Use [eddystoneUidLayout] instead.
  // ignore: constant_identifier_names
  @Deprecated('Use eddystoneUidLayout instead')
  static const String EDDYSTONE_UID_LAYOUT = eddystoneUidLayout;

  /// @deprecated Use [eddystoneUrlLayout] instead.
  // ignore: constant_identifier_names
  @Deprecated('Use eddystoneUrlLayout instead')
  static const String EDDYSTONE_URL_LAYOUT = eddystoneUrlLayout;

  /// @deprecated Use [uriBeaconLayout] instead.
  // ignore: constant_identifier_names
  @Deprecated('Use uriBeaconLayout instead')
  static const String URI_BEACON_LAYOUT = uriBeaconLayout;

  String? _uuid;
  int? _majorId;
  int? _minorId;
  int? _transmissionPower;
  int? _advertiseMode;
  String? _identifier;
  String? _layout;
  int? _manufacturerId;
  List<int>? _extraData;

  static const MethodChannel _methodChannel = MethodChannel(
    'pl.pszklarska.beaconbroadcast/beacon_state',
  );

  static const EventChannel _eventChannel = EventChannel(
    'pl.pszklarska.beaconbroadcast/beacon_events',
  );

  /// Sets UUID for beacon.
  ///
  /// [uuid] is a random string identifier, e.g. "2f234454-cf6d-4a0f-adf2-f4911ba9ffa6"
  ///
  /// This parameter is required for the default layout.
  ///
  /// Returns this instance for method chaining.
  BeaconBroadcast setUUID(String uuid) {
    if (uuid.isEmpty) {
      throw const IllegalArgumentException('UUID must not be empty');
    }
    _uuid = uuid;
    return this;
  }

  /// Sets major id for beacon.
  ///
  /// [majorId] is an integer identifier with range between 0 and 65535.
  ///
  /// This parameter is required for the default layout.
  ///
  /// Returns this instance for method chaining.
  BeaconBroadcast setMajorId(int majorId) {
    if (majorId < 0 || majorId > 65535) {
      throw IllegalArgumentException(
        'MajorId must be between 0 and 65535, got: $majorId',
      );
    }
    _majorId = majorId;
    return this;
  }

  /// Sets minor id for beacon.
  ///
  /// [minorId] is an integer identifier with range between 0 and 65535.
  ///
  /// This parameter is required for the default layout.
  ///
  /// Returns this instance for method chaining.
  BeaconBroadcast setMinorId(int minorId) {
    if (minorId < 0 || minorId > 65535) {
      throw IllegalArgumentException(
        'MinorId must be between 0 and 65535, got: $minorId',
      );
    }
    _minorId = minorId;
    return this;
  }

  /// Sets identifier for beacon.
  ///
  /// This parameter is **iOS only** (it has no effect on Android).
  /// It's a string that identifies the beacon additionally.
  ///
  /// See also: [Turning an iOS Device into an iBeacon](https://developer.apple.com/documentation/corelocation/turning_an_ios_device_into_an_ibeacon)
  ///
  /// This parameter is optional.
  ///
  /// Returns this instance for method chaining.
  BeaconBroadcast setIdentifier(String identifier) {
    _identifier = identifier;
    return this;
  }

  /// Sets transmission power for beacon.
  ///
  /// Transmission power determines the strength of the signal transmitted by the beacon.
  /// It's measured in dBm. Higher values amplify the signal strength, but also increase
  /// power usage.
  ///
  /// This parameter is optional. If not set, the default value for Android will be -59 dBm
  /// and for iOS the default received signal strength indicator (RSSI) value associated
  /// with the iOS device.
  ///
  /// See also: [Turning an iOS Device into an iBeacon](https://developer.apple.com/documentation/corelocation/turning_an_ios_device_into_an_ibeacon)
  ///
  /// Returns this instance for method chaining.
  BeaconBroadcast setTransmissionPower(int transmissionPower) {
    _transmissionPower = transmissionPower;
    return this;
  }

  /// Sets advertise mode for beacon.
  ///
  /// Advertise mode determines advertising frequency and power consumption.
  ///
  /// This parameter is **Android only** (it has no effect on iOS).
  /// It is optional. If not set, the default value will be [AdvertiseMode.balanced].
  ///
  /// Available options:
  /// - [AdvertiseMode.lowPower]: Consumes less energy, but larger broadcast interval
  /// - [AdvertiseMode.balanced]: Default - Balance between energy usage and broadcast interval
  /// - [AdvertiseMode.lowLatency]: Consumes more energy, but smaller broadcast interval
  ///
  /// Returns this instance for method chaining.
  BeaconBroadcast setAdvertiseMode(AdvertiseMode advertiseMode) {
    _advertiseMode = _advertiseModeToInt(advertiseMode);
    return this;
  }

  /// Sets beacon layout.
  ///
  /// This parameter is **Android only**. It's optional, the default is [altbeaconLayout].
  ///
  /// Available options:
  /// - [altbeaconLayout]
  /// - [eddystoneTlmLayout]
  /// - [eddystoneUidLayout]
  /// - [eddystoneUrlLayout]
  /// - [uriBeaconLayout]
  ///
  /// **For iOS**, layout will always be iBeacon.
  ///
  /// Returns this instance for method chaining.
  BeaconBroadcast setLayout(String layout) {
    if (layout.isEmpty) {
      throw const IllegalArgumentException('Layout must not be empty');
    }
    _layout = layout;
    return this;
  }

  /// Sets manufacturer id.
  ///
  /// This parameter is **Android only**. It's optional, the default is Radius Network.
  ///
  /// For more information, check the full list of
  /// [Company Identifiers](https://www.bluetooth.com/specifications/assigned-numbers/company-identifiers/).
  ///
  /// **For iOS**, the manufacturer will always be Apple.
  ///
  /// Returns this instance for method chaining.
  BeaconBroadcast setManufacturerId(int manufacturerId) {
    _manufacturerId = manufacturerId;
    return this;
  }

  /// Sets extra data.
  ///
  /// This parameter is **Android only**. If beacon layout allows it, you can
  /// add extra bytes to the data transmitted by the beacon.
  /// Each value must be within a range 0-255.
  ///
  /// For more information, check section
  /// [Adding extra data](https://github.com/pszklarska/beacon_broadcast#adding-extra-data)
  /// in the documentation.
  ///
  /// **For iOS**, beacon layout doesn't allow transmitting any extra data.
  ///
  /// This parameter is optional.
  ///
  /// Returns this instance for method chaining.
  ///
  /// Throws [IllegalArgumentException] if any value is outside the valid range.
  BeaconBroadcast setExtraData(List<int> extraData) {
    if (extraData.any((value) => value < 0 || value > 255)) {
      throw const IllegalArgumentException(
        'Extra data values must be within a byte range 0-255',
      );
    }
    _extraData = List<int>.unmodifiable(extraData);
    return this;
  }

  /// Starts beacon advertising.
  ///
  /// Before starting, you must set [setUUID].
  /// For the default layout, parameters [setMajorId] and [setMinorId] are also required.
  /// Other parameters such as [setIdentifier], [setTransmissionPower], [setAdvertiseMode],
  /// [setLayout], [setManufacturerId] are optional.
  ///
  /// For Android, beacon layout is by default set to AltBeacon.
  /// See also: [AltBeacon - Transmitting as a Beacon](https://altbeacon.github.io/android-beacon-library/beacon-transmitter.html)
  ///
  /// On Android, it's required to have Bluetooth turned on and to grant the app
  /// permission to location and Bluetooth advertising (Android 12+).
  ///
  /// For iOS, beacon is broadcasting as an iBeacon.
  /// See also: [Turning an iOS Device into an iBeacon](https://developer.apple.com/documentation/corelocation/turning_an_ios_device_into_an_ibeacon)
  ///
  /// **Important**: After advertising your app as a beacon, your app must continue running
  /// in the foreground to broadcast the needed Bluetooth signals. If the user quits the app,
  /// the system stops advertising the device as a peripheral over Bluetooth.
  ///
  /// Throws [IllegalArgumentException] if required parameters are missing or invalid.
  /// Throws [PlatformException] if the native platform call fails.
  Future<void> start() async {
    if (_uuid == null || _uuid!.isEmpty) {
      throw const IllegalArgumentException('UUID must not be null or empty');
    }

    if ((_layout == null || _layout == altbeaconLayout) &&
        (_majorId == null || _minorId == null)) {
      throw IllegalArgumentException(
        'MajorId and minorId must not be null for default layout: '
        'majorId: $_majorId, minorId: $_minorId',
      );
    }

    final Map<String, dynamic> params = <String, dynamic>{
      'uuid': _uuid,
      'majorId': _majorId,
      'minorId': _minorId,
      'transmissionPower': _transmissionPower,
      'advertiseMode': _advertiseMode,
      'identifier': _identifier,
      'layout': _layout,
      'manufacturerId': _manufacturerId,
      'extraData': _extraData,
    };

    try {
      await _methodChannel.invokeMethod<void>('start', params);
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message ?? 'Failed to start beacon advertising',
        details: e.details,
        stacktrace: e.stacktrace,
      );
    }
  }

  /// Stops beacon advertising.
  ///
  /// Throws [PlatformException] if the native platform call fails.
  Future<void> stop() async {
    try {
      await _methodChannel.invokeMethod<void>('stop');
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message ?? 'Failed to stop beacon advertising',
        details: e.details,
        stacktrace: e.stacktrace,
      );
    }
  }

  /// Returns `true` if beacon is advertising, `false` otherwise.
  ///
  /// Throws [PlatformException] if the native platform call fails.
  Future<bool> isAdvertising() async {
    try {
      final bool? result = await _methodChannel.invokeMethod<bool>(
        'isAdvertising',
      );
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message ?? 'Failed to check advertising state',
        details: e.details,
        stacktrace: e.stacktrace,
      );
    }
  }

  /// Returns a stream of booleans indicating if beacon is advertising.
  ///
  /// After listening to this stream, you'll be notified about changes in beacon
  /// advertising state. Returns `true` if beacon is advertising.
  ///
  /// See also: [isAdvertising]
  ///
  /// **Note**: Remember to cancel the subscription when done to avoid memory leaks.
  Stream<bool> getAdvertisingStateChange() {
    return _eventChannel.receiveBroadcastStream().cast<bool>();
  }

  /// Checks if device supports transmission.
  ///
  /// For iOS, it always returns [BeaconStatus.supported].
  ///
  /// Possible values (for Android):
  /// - [BeaconStatus.supported]: Device supports transmission
  /// - [BeaconStatus.notSupportedMinSdk]: Android system version is lower than 21
  /// - [BeaconStatus.notSupportedBle]: BLE is not supported on this device
  /// - [BeaconStatus.notSupportedCannotGetAdvertiser]: Device does not have a compatible
  ///   chipset or driver
  ///
  /// Throws [PlatformException] if the native platform call fails.
  Future<BeaconStatus> checkTransmissionSupported() async {
    try {
      final int? isTransmissionSupported = await _methodChannel
          .invokeMethod<int>('isTransmissionSupported');
      return _beaconStatusFromInt(isTransmissionSupported);
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message ?? 'Failed to check transmission support',
        details: e.details,
        stacktrace: e.stacktrace,
      );
    }
  }
}

/// Exception thrown when invalid arguments are provided to beacon configuration methods.
class IllegalArgumentException implements Exception {
  /// Creates an [IllegalArgumentException] with the given [message].
  const IllegalArgumentException(this.message);

  /// The error message explaining why the exception was thrown.
  final String message;

  @override
  String toString() => 'IllegalArgumentException: $message';
}

/// Status indicating whether the device supports beacon transmission.
enum BeaconStatus {
  /// Device supports transmitting as a beacon.
  supported,

  /// Android system version on the device is too low (minimum is 21).
  notSupportedMinSdk,

  /// Device doesn't support Bluetooth Low Energy.
  notSupportedBle,

  /// Device's Bluetooth chipset or driver doesn't support transmitting.
  notSupportedCannotGetAdvertiser,
}

const Map<int, BeaconStatus> _intToBeaconStatus = <int, BeaconStatus>{
  0: BeaconStatus.supported,
  1: BeaconStatus.notSupportedMinSdk,
  2: BeaconStatus.notSupportedBle,
};

BeaconStatus _beaconStatusFromInt(int? value) {
  if (value == null || !_intToBeaconStatus.containsKey(value)) {
    return BeaconStatus.notSupportedCannotGetAdvertiser;
  }
  return _intToBeaconStatus[value]!;
}

/// Advertise mode for beacon transmission (Android only).
enum AdvertiseMode {
  /// Consumes less energy, but larger broadcast interval.
  lowPower,

  /// Balance between energy usage and broadcast interval (default).
  balanced,

  /// Consumes more energy, but smaller broadcast interval.
  lowLatency,
}

const Map<int, AdvertiseMode> _intToAdvertiseMode = <int, AdvertiseMode>{
  0: AdvertiseMode.lowPower,
  1: AdvertiseMode.balanced,
  2: AdvertiseMode.lowLatency,
};

int? _advertiseModeToInt(AdvertiseMode advMode) {
  for (final MapEntry<int, AdvertiseMode> entry
      in _intToAdvertiseMode.entries) {
    if (entry.value == advMode) {
      return entry.key;
    }
  }
  return null;
}
