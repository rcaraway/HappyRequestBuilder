// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HappyRequestBuilder",
    products: [
        .library(
            name: "HappyRequestBuilder",
            targets: ["HappyRequestBuilder"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HappyRequestBuilder",
            dependencies: []),
        .testTarget(
            name: "HappyRequestBuilderTests",
            dependencies: ["HappyRequestBuilder"]),
    ]
)
