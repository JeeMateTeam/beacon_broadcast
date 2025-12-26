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

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:beacon_broadcast/beacon_broadcast_platform_interface.dart';

/// An implementation of [BeaconBroadcastPlatform] that uses method channels.
class MethodChannelBeaconBroadcast extends BeaconBroadcastPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(
    'pl.pszklarska.beaconbroadcast/beacon_state',
  );

  /// The event channel used to receive advertising state changes.
  @visibleForTesting
  final eventChannel = const EventChannel(
    'pl.pszklarska.beaconbroadcast/beacon_events',
  );

  @override
  Future<void> start(Map<String, dynamic> params) async {
    try {
      await methodChannel.invokeMethod<void>('start', params);
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message ?? 'Failed to start beacon advertising',
        details: e.details,
        stacktrace: e.stacktrace,
      );
    }
  }

  @override
  Future<void> stop() async {
    try {
      await methodChannel.invokeMethod<void>('stop');
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message ?? 'Failed to stop beacon advertising',
        details: e.details,
        stacktrace: e.stacktrace,
      );
    }
  }

  @override
  Future<bool> isAdvertising() async {
    try {
      final bool? result = await methodChannel.invokeMethod<bool>(
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

  @override
  Stream<bool> getAdvertisingStateChange() {
    return eventChannel.receiveBroadcastStream().cast<bool>();
  }

  @override
  Future<int> isTransmissionSupported() async {
    try {
      final int? result = await methodChannel.invokeMethod<int>(
        'isTransmissionSupported',
      );
      return result ?? 3; // Default to notSupportedCannotGetAdvertiser
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
