// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pi_task",
    dependencies: [
	.package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.5.6"),
    .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "4.7.0")
    ],
    targets: [
        .target(
            name: "pi_task",
            dependencies: ["Kitura", "SWXMLHash"])
    ]
)
