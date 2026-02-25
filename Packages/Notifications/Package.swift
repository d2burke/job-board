// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Notifications",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Notifications", targets: ["Notifications"])
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../SharedModels"),
        .package(path: "../Networking")
    ],
    targets: [
        .target(name: "Notifications", dependencies: ["DesignSystem", "SharedModels", "Networking"]),
        .testTarget(name: "NotificationsTests", dependencies: ["Notifications"])
    ]
)
