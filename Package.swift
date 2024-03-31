// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "XMLRPCCoder",
    products: [
        .library(name: "XMLRPCCoder", targets: ["XMLRPCCoder"]),
        .library(name: "XMLAssertions", targets: ["XMLAssertions"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ilg/swift-meta-serialization.git",
            branch: "fix-spm"
        ),
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMajor(from: "1.1.0")
        ),
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat",
            from: "0.53.5"
        ),
    ],
    targets: [
        .target(
            name: "XMLRPCCoder",
            dependencies: [
                .product(name: "MetaSerialization", package: "swift-meta-serialization"),
                .product(name: "OrderedCollections", package: "swift-collections"),
            ]
        ),
        .testTarget(
            name: "XMLRPCCoderTests",
            dependencies: [
                .target(name: "XMLRPCCoder"),
                .target(name: "XMLAssertions"),
            ]
        ),
        .target(
            name: "XMLAssertions",
            dependencies: [.target(name: "XMLRPCCoder")]
        ),
    ]
)
