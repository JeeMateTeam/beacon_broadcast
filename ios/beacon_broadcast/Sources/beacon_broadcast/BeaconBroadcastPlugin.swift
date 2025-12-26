import Flutter
import UIKit

@objc public class BeaconBroadcastPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        SwiftBeaconBroadcastPlugin.register(with: registrar)
    }
}

