// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Superfluid",
    dependencies: [
        //.package(url: "https://github.com/AlwaysRightInstitute/cows.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.1.0"),
        .package(url: "https://github.com/AlwaysRightInstitute/mustache.git", from: "0.5.1")
    ],
    targets: [ .target(name: "Superfluid", dependencies: [ "NIO", "NIOHTTP1", "mustache"]) ]
)
