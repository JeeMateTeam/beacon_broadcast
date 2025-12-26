import 'dart:async';

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel methodChannel = MethodChannel(
    'pl.pszklarska.beaconbroadcast/beacon_state',
  );

  setUp(() {
    // ignore: deprecated_member_use
    methodChannel.setMockMethodCallHandler(null);
  });

  tearDown(() {
    // ignore: deprecated_member_use
    methodChannel.setMockMethodCallHandler(null);
  });

  void onStartMethodReturn(Future<void> value) {
    // ignore: deprecated_member_use
    methodChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'start') {
        return value;
      }
    });
  }

  void onStopMethodReturn(Future<void> value) {
    // ignore: deprecated_member_use
    methodChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'stop') {
        return value;
      }
    });
  }

  void onIsAdvertisingMethodReturn(Future<bool?> value) {
    // ignore: deprecated_member_use
    methodChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'isAdvertising') {
        return value;
      }
    });
  }

  void onIsTransmissionSupportedMethodReturn(Future<int?> value) {
    // ignore: deprecated_member_use
    methodChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'isTransmissionSupported') {
        return value;
      }
    });
  }

  group('starting beacon advertising', () {
    test('when all data is set returns normally', () async {
      onStartMethodReturn(Future<void>.value());

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
      onStartMethodReturn(Future<void>.value());
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
      onStartMethodReturn(Future<void>.value());
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
      onStartMethodReturn(Future<void>.value());
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
        onStartMethodReturn(Future<void>.value());
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
        onStartMethodReturn(Future<void>.value());
        expect(
          () => BeaconBroadcast().setUUID('uuid').setExtraData([270]).start(),
          throwsA(isA<IllegalArgumentException>()),
        );
      },
    );

    test('when uuid is empty throws exception', () async {
      onStartMethodReturn(Future<void>.value());
      expect(
        () => BeaconBroadcast().setUUID('').start(),
        throwsA(isA<IllegalArgumentException>()),
      );
    });

    test('when major id is out of range throws exception', () async {
      onStartMethodReturn(Future<void>.value());
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
      onStartMethodReturn(Future<void>.value());
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
        onStartMethodReturn(Future<void>.value());
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
        onStartMethodReturn(Future<void>.value());
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
        onStartMethodReturn(Future<void>.value());
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
        onStartMethodReturn(Future<void>.value());
        expect(
          () => BeaconBroadcast().setUUID('uuid').setLayout('').start(),
          throwsA(isA<IllegalArgumentException>()),
        );
      });
    });
  });

  group('checking if transmission is supported', () {
    test('when device returns 0 return BeaconStatus.supported', () async {
      onIsTransmissionSupportedMethodReturn(Future<int?>.value(0));
      expect(
        await BeaconBroadcast().checkTransmissionSupported(),
        BeaconStatus.supported,
      );
    });

    test(
      'when device returns 1 return BeaconStatus.notSupportedMinSdk',
      () async {
        onIsTransmissionSupportedMethodReturn(Future<int?>.value(1));
        expect(
          await BeaconBroadcast().checkTransmissionSupported(),
          BeaconStatus.notSupportedMinSdk,
        );
      },
    );

    test('when device returns 2 return BeaconStatus.notSupportedBle', () async {
      onIsTransmissionSupportedMethodReturn(Future<int?>.value(2));
      expect(
        await BeaconBroadcast().checkTransmissionSupported(),
        BeaconStatus.notSupportedBle,
      );
    });

    test(
      'when device returns other value return BeaconStatus.notSupportedCannotGetAdvertiser',
      () async {
        onIsTransmissionSupportedMethodReturn(Future<int?>.value(3));
        expect(
          await BeaconBroadcast().checkTransmissionSupported(),
          BeaconStatus.notSupportedCannotGetAdvertiser,
        );
      },
    );

    test(
      'when device returns null return BeaconStatus.notSupportedCannotGetAdvertiser',
      () async {
        onIsTransmissionSupportedMethodReturn(Future<int?>.value(null));
        expect(
          await BeaconBroadcast().checkTransmissionSupported(),
          BeaconStatus.notSupportedCannotGetAdvertiser,
        );
      },
    );
  });

  group('checking advertising state', () {
    test('beacon is advertising returns true', () async {
      onIsAdvertisingMethodReturn(Future<bool?>.value(true));
      expect(await BeaconBroadcast().isAdvertising(), isTrue);
    });

    test('beacon is not advertising returns false', () async {
      onIsAdvertisingMethodReturn(Future<bool?>.value(false));
      expect(await BeaconBroadcast().isAdvertising(), isFalse);
    });

    test('beacon isAdvertising returns false when null', () async {
      onIsAdvertisingMethodReturn(Future<bool?>.value(null));
      expect(await BeaconBroadcast().isAdvertising(), isFalse);
    });
  });

  group('stopping beacon', () {
    test('beacon stops returns normally', () async {
      onStopMethodReturn(Future<void>.value());
      expect(() => BeaconBroadcast().stop(), returnsNormally);
    });
  });

  group('advertising state change stream', () {
    test('getAdvertisingStateChange returns a stream', () {
      final Stream<bool> stream = BeaconBroadcast().getAdvertisingStateChange();
      expect(stream, isA<Stream<bool>>());
    });
  });
}
