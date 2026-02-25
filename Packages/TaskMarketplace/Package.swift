// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TaskMarketplace",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "TaskMarketplace", targets: ["TaskMarketplace"])
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../SharedModels"),
        .package(path: "../Networking")
    ],
    targets: [
        .target(name: "TaskMarketplace", dependencies: ["DesignSystem", "SharedModels", "Networking"]),
        .testTarget(name: "TaskMarketplaceTests", dependencies: ["TaskMarketplace"])
    ]
)
