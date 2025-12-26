import 'dart:async';

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:beacon_broadcast/beacon_broadcast_method_channel.dart';
import 'package:beacon_broadcast/beacon_broadcast_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class MockBeaconBroadcastPlatform extends BeaconBroadcastPlatform {
  Future<void> Function(Map<String, dynamic>)? startHandler;
  Future<void> Function()? stopHandler;
  Future<bool> Function()? isAdvertisingHandler;
  Future<int> Function()? isTransmissionSupportedHandler;
  Stream<bool>? advertisingStateChangeStream;

  @override
  Future<void> start(Map<String, dynamic> params) {
    if (startHandler != null) {
      return startHandler!(params);
    }
    return Future<void>.value();
  }

  @override
  Future<void> stop() {
    if (stopHandler != null) {
      return stopHandler!();
    }
    return Future<void>.value();
  }

  @override
  Future<bool> isAdvertising() {
    if (isAdvertisingHandler != null) {
      return isAdvertisingHandler!();
    }
    return Future<bool>.value(false);
  }

  @override
  Stream<bool> getAdvertisingStateChange() {
    return advertisingStateChangeStream ?? const Stream<bool>.empty();
  }

  @override
  Future<int> isTransmissionSupported() {
    if (isTransmissionSupportedHandler != null) {
      return isTransmissionSupportedHandler!();
    }
    return Future<int>.value(3);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockBeaconBroadcastPlatform mockPlatform;

  setUp(() {
    mockPlatform = MockBeaconBroadcastPlatform();
    BeaconBroadcastPlatform.instance = mockPlatform;
  });

  tearDown(() {
    // Reset to default implementation
    BeaconBroadcastPlatform.instance = MethodChannelBeaconBroadcast();
  });

  group('starting beacon advertising', () {
    test('when all data is set returns normally', () async {
      mockPlatform.startHandler = (_) => Future<void>.value();

      expect(
        () => BeaconBroadcast()
            .setUUID('uuid')
            .setMajorId(1)
            .setMinorId(1)
            .setTransmissionPower(-59)
            .setAdvertiseMode(AdvertiseMode.lowLatency)
            .setManufacturerId(0)
            .setExtraData([100])
            .setIdentifier('identifier')
            .start(),
        returnsNormally,
      );
    });

    test('when uuid is not set throws exception', () async {
      mockPlatform.startHandler = (_) => Future<void>.value();
      expect(
        () => BeaconBroadcast()
            .setMajorId(1)
            .setMinorId(1)
            .setTransmissionPower(-59)
            .setIdentifier('identifier')
            .start(),
        throwsA(isA<IllegalArgumentException>()),
      );
    });

    test('when major id is not set throws exception', () async {
      mockPlatform.startHandler = (_) => Future<void>.value();
      expect(
        () => BeaconBroadcast()
            .setUUID('uuid')
            .setMinorId(1)
            .setTransmissionPower(-59)
            .setIdentifier('identifier')
            .start(),
        throwsA(isA<IllegalArgumentException>()),
      );
    });

    test('when minor id is not set throws exception', () async {
      mockPlatform.startHandler = (_) => Future<void>.value();
      expect(
        () => BeaconBroadcast()
            .setUUID('uuid')
            .setMajorId(1)
            .setTransmissionPower(-59)
            .setIdentifier('identifier')
            .start(),
        throwsA(isA<IllegalArgumentException>()),
      );
    });

    test(
      'when identifier and transmission power are not set starts normally',
      () async {
        mockPlatform.startHandler = (_) => Future<void>.value();
        expect(
          () => BeaconBroadcast()
              .setUUID('uuid')
              .setMajorId(1)
              .setMinorId(1)
              .start(),
          returnsNormally,
        );
      },
    );

    test(
      'when extra data contains integer out of range throws exception',
      () async {
        mockPlatform.startHandler = (_) => Future<void>.value();
        expect(
          () => BeaconBroadcast().setUUID('uuid').setExtraData([270]).start(),
          throwsA(isA<IllegalArgumentException>()),
        );
      },
    );

    test('when uuid is empty throws exception', () async {
      mockPlatform.startHandler = (_) => Future<void>.value();
      expect(
        () => BeaconBroadcast().setUUID('').start(),
        throwsA(isA<IllegalArgumentException>()),
      );
    });

    test('when major id is out of range throws exception', () async {
      mockPlatform.startHandler = (_) => Future<void>.value();
      expect(
        () => BeaconBroadcast()
            .setUUID('uuid')
            .setMajorId(65536)
            .setMinorId(1)
            .start(),
        throwsA(isA<IllegalArgumentException>()),
      );
    });

    test('when minor id is out of range throws exception', () async {
      mockPlatform.startHandler = (_) => Future<void>.value();
      expect(
        () => BeaconBroadcast()
            .setUUID('uuid')
            .setMajorId(1)
            .setMinorId(65536)
            .start(),
        throwsA(isA<IllegalArgumentException>()),
      );
    });

    group('when custom layout is set', () {
      test('and minor id is not set returns normally', () async {
        mockPlatform.startHandler = (_) => Future<void>.value();
        expect(
          () => BeaconBroadcast()
              .setUUID('uuid')
              .setMajorId(1)
              .setTransmissionPower(-59)
              .setIdentifier('identifier')
              .setLayout('layout')
              .start(),
          returnsNormally,
        );
      });

      test('and major id is not set returns normally', () async {
        mockPlatform.startHandler = (_) => Future<void>.value();
        expect(
          () => BeaconBroadcast()
              .setUUID('uuid')
              .setMinorId(1)
              .setTransmissionPower(-59)
              .setIdentifier('identifier')
              .setLayout('layout')
              .start(),
          returnsNormally,
        );
      });

      test('and UUID is not set throws exception', () async {
        mockPlatform.startHandler = (_) => Future<void>.value();
        expect(
          () => BeaconBroadcast()
              .setMinorId(1)
              .setTransmissionPower(-59)
              .setIdentifier('identifier')
              .setLayout('layout')
              .start(),
          throwsA(isA<IllegalArgumentException>()),
        );
      });

      test('when layout is empty throws exception', () async {
        mockPlatform.startHandler = (_) => Future<void>.value();
        expect(
          () => BeaconBroadcast().setUUID('uuid').setLayout('').start(),
          throwsA(isA<IllegalArgumentException>()),
        );
      });
    });
  });

  group('checking if transmission is supported', () {
    test('when device returns 0 return BeaconStatus.supported', () async {
      mockPlatform.isTransmissionSupportedHandler = () => Future<int>.value(0);
      expect(
        await BeaconBroadcast().checkTransmissionSupported(),
        BeaconStatus.supported,
      );
    });

    test(
      'when device returns 1 return BeaconStatus.notSupportedMinSdk',
      () async {
        mockPlatform.isTransmissionSupportedHandler = () =>
            Future<int>.value(1);
        expect(
          await BeaconBroadcast().checkTransmissionSupported(),
          BeaconStatus.notSupportedMinSdk,
        );
      },
    );

    test('when device returns 2 return BeaconStatus.notSupportedBle', () async {
      mockPlatform.isTransmissionSupportedHandler = () => Future<int>.value(2);
      expect(
        await BeaconBroadcast().checkTransmissionSupported(),
        BeaconStatus.notSupportedBle,
      );
    });

    test(
      'when device returns other value return BeaconStatus.notSupportedCannotGetAdvertiser',
      () async {
        mockPlatform.isTransmissionSupportedHandler = () =>
            Future<int>.value(3);
        expect(
          await BeaconBroadcast().checkTransmissionSupported(),
          BeaconStatus.notSupportedCannotGetAdvertiser,
        );
      },
    );
  });

  group('checking advertising state', () {
    test('beacon is advertising returns true', () async {
      mockPlatform.isAdvertisingHandler = () => Future<bool>.value(true);
      expect(await BeaconBroadcast().isAdvertising(), isTrue);
    });

    test('beacon is not advertising returns false', () async {
      mockPlatform.isAdvertisingHandler = () => Future<bool>.value(false);
      expect(await BeaconBroadcast().isAdvertising(), isFalse);
    });
  });

  group('stopping beacon', () {
    test('beacon stops returns normally', () async {
      mockPlatform.stopHandler = Future<void>.value;
      expect(() => BeaconBroadcast().stop(), returnsNormally);
    });
  });

  group('advertising state change stream', () {
    test('getAdvertisingStateChange returns a stream', () {
      mockPlatform.advertisingStateChangeStream = Stream<bool>.value(true);
      final Stream<bool> stream = BeaconBroadcast().getAdvertisingStateChange();
      expect(stream, isA<Stream<bool>>());
    });
  });
}
