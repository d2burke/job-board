// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Authentication",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Authentication", targets: ["Authentication"])
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../SharedModels"),
        .package(path: "../Networking")
    ],
    targets: [
        .target(name: "Authentication", dependencies: ["DesignSystem", "SharedModels", "Networking"]),
        .testTarget(name: "AuthenticationTests", dependencies: ["Authentication"])
    ]
)
