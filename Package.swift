// swift-tools-version:4.0
//
//  Package.swift
//  MicroExpress
//
//  Created by Helge Hess on 09.03.18.
//  Copyright © 2018 ZeeZide. All rights reserved.
//
import PackageDescription

let package = Package(
    name: "MicroExpress",
    dependencies: [
        //.package(url: "https://github.com/AlwaysRightInstitute/cows.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.1.0"),
        .package(url: "https://github.com/AlwaysRightInstitute/mustache.git", from: "0.5.1")
    ],
    targets: [ .target(name: "MicroExpress", dependencies: [ "NIO", "NIOHTTP1", "mustache"]) ]
)
