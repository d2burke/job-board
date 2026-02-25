// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Profile",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Profile", targets: ["Profile"])
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../SharedModels"),
        .package(path: "../Networking")
    ],
    targets: [
        .target(name: "Profile", dependencies: ["DesignSystem", "SharedModels", "Networking"]),
        .testTarget(name: "ProfileTests", dependencies: ["Profile"])
    ]
)
