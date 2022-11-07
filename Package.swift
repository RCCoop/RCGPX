// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RCGPX",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_12),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "RCGPX",
            targets: ["RCGPX"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tadija/AEXML.git", from:"4.6.0"),
    ],
    targets: [
        .target(
            name: "RCGPX",
            dependencies: ["AEXML"]),
        .testTarget(
            name: "RCGPXTests",
            dependencies: ["RCGPX", "AEXML"],
            resources: [.process("GPSVisSample.gpx")]
        ),
    ]
)
