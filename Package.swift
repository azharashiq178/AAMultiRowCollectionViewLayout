// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AAMultiRowCollectionViewLayout",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "AAMultiRowCollectionViewLayout",
            targets: ["AAMultiRowCollectionViewLayout"]),
    ],
    dependencies: [
        // no dependencies
        .package(url: "https://github.com/azharashiq178/AAMultiRowCollectionViewLayout", from: "0.0.2"),
    ],
    targets: [
        .target(name: "AAMultiRowCollectionViewLayout", path: "AAMultiRowCollectionViewLayout")
    ]
)
