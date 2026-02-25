// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Messaging",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Messaging", targets: ["Messaging"])
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../SharedModels"),
        .package(path: "../Networking")
    ],
    targets: [
        .target(name: "Messaging", dependencies: ["DesignSystem", "SharedModels", "Networking"]),
        .testTarget(name: "MessagingTests", dependencies: ["Messaging"])
    ]
)
