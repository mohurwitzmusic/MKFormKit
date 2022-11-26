// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "MKFormKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "MKFormKit",
            targets: ["MKFormKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "MKFormKit",
            dependencies: []),
        .testTarget(
            name: "MKFormKitTests",
            dependencies: ["MKFormKit"]),
    ]
)
