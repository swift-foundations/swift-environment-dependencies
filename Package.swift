// swift-tools-version: 6.4

// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-environment-dependencies open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-environment-dependencies
// project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
    name: "swift-environment-dependencies",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Environment Dependencies Core",
            targets: ["Environment Dependencies Core"]
        ),
        .library(
            name: "Environment Dependencies Foundation Integration",
            targets: ["Environment Dependencies Foundation Integration"]
        ),
        // Compatibility-only migration facade. New consumers must select Core or
        // Foundation Integration directly; this target accepts no new behavior.
        .library(
            name: "Environment Dependencies",
            targets: ["Environment Dependencies"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-environment.git", branch: "main"),
        .package(
            url: "https://github.com/swift-foundations/swift-dependencies.git",
            branch: "main"
        ),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Environment Dependencies Core",
            dependencies: [
                .product(name: "Environment", package: "swift-environment"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .target(
            name: "Environment Dependencies Foundation Integration",
            dependencies: [
                "Environment Dependencies Core",
                .product(name: "Environment", package: "swift-environment"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "Environment Dependencies",
            dependencies: [
                "Environment Dependencies Core",
                "Environment Dependencies Foundation Integration",
            ]
        ),
        .testTarget(
            name: "Environment Dependencies Core Tests",
            dependencies: [
                "Environment Dependencies Core",
                .product(name: "Dependencies Test Support", package: "swift-dependencies"),
            ]
        ),
        .testTarget(
            name: "Environment Dependencies Foundation Integration Tests",
            dependencies: [
                "Environment Dependencies Foundation Integration",
                .product(name: "Dependencies Test Support", package: "swift-dependencies"),
            ]
        ),
        .testTarget(
            name: "Environment Dependencies Compatibility Tests",
            dependencies: ["Environment Dependencies"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
