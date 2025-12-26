// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "beacon_broadcast",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "beacon_broadcast",
            targets: ["beacon_broadcast"]
        ),
        .library(
            name: "beacon-broadcast",
            targets: ["beacon_broadcast"]
        ),
    ],
    dependencies: [
        // Flutter will be added automatically by Flutter tooling
    ],
    targets: [
        .target(
            name: "beacon_broadcast",
            dependencies: [],
            path: "Sources/beacon_broadcast",
            exclude: [],
            linkerSettings: [
                .linkedFramework("CoreBluetooth"),
                .linkedFramework("CoreLocation"),
            ]
        ),
    ]
)
