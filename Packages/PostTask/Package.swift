// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PostTask",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "PostTask", targets: ["PostTask"])
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../SharedModels"),
        .package(path: "../Networking")
    ],
    targets: [
        .target(name: "PostTask", dependencies: ["DesignSystem", "SharedModels", "Networking"]),
        .testTarget(name: "PostTaskTests", dependencies: ["PostTask"])
    ]
)
