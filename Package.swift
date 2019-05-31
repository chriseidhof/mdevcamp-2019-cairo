// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CairoExample6",
    dependencies: [
    ],
    targets: [
        .systemLibrary(
            name: "CCairo",
            pkgConfig: "cairo"),
        .target(
            name: "Cairo",
            dependencies: ["CCairo"]),
        .target(
            name: "CairoExample6",
            dependencies: ["Cairo"]),
        .testTarget(
            name: "CairoExample6Tests",
            dependencies: ["CairoExample6"]),
    ]
)
