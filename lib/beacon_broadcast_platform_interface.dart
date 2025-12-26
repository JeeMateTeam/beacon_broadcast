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

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:beacon_broadcast/beacon_broadcast_method_channel.dart';

/// The interface that platform-specific implementations of beacon_broadcast must extend.
///
/// This class allows the platform implementation to extend the platform interface
/// rather than implementing it directly, which ensures that new methods added
/// to the platform interface don't break existing implementations.
abstract class BeaconBroadcastPlatform extends PlatformInterface {
  /// Constructs a BeaconBroadcastPlatform.
  BeaconBroadcastPlatform() : super(token: _token);

  static final Object _token = Object();

  static BeaconBroadcastPlatform _instance = MethodChannelBeaconBroadcast();

  /// The default instance of [BeaconBroadcastPlatform] to use.
  ///
  /// Defaults to [MethodChannelBeaconBroadcast].
  static BeaconBroadcastPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BeaconBroadcastPlatform] when
  /// they register themselves.
  static set instance(BeaconBroadcastPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Starts beacon advertising with the given parameters.
  ///
  /// Throws PlatformException if the native platform call fails.
  Future<void> start(Map<String, dynamic> params) {
    throw UnimplementedError('start() has not been implemented.');
  }

  /// Stops beacon advertising.
  ///
  /// Throws PlatformException if the native platform call fails.
  Future<void> stop() {
    throw UnimplementedError('stop() has not been implemented.');
  }

  /// Returns `true` if beacon is advertising, `false` otherwise.
  ///
  /// Throws PlatformException if the native platform call fails.
  Future<bool> isAdvertising() {
    throw UnimplementedError('isAdvertising() has not been implemented.');
  }

  /// Returns a stream of booleans indicating if beacon is advertising.
  ///
  /// After listening to this stream, you'll be notified about changes in beacon
  /// advertising state. Returns `true` if beacon is advertising.
  Stream<bool> getAdvertisingStateChange() {
    throw UnimplementedError(
      'getAdvertisingStateChange() has not been implemented.',
    );
  }

  /// Checks if device supports transmission.
  ///
  /// Returns an integer indicating the support level:
  /// - 0: Device supports transmission
  /// - 1: Android system version is too low
  /// - 2: BLE is not supported
  /// - 3: Device does not have a compatible chipset or driver
  ///
  /// Throws PlatformException if the native platform call fails.
  Future<int> isTransmissionSupported() {
    throw UnimplementedError(
      'isTransmissionSupported() has not been implemented.',
    );
  }
}
