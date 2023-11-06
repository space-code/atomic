// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Atomic",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v11),
    ],
    products: [
        .library(name: "Atomic", targets: ["Atomic"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Atomic",
            dependencies: []
        ),
        .testTarget(
            name: "AtomicTests",
            dependencies: ["Atomic"]
        ),
    ]
)
