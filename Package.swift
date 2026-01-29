// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "metal",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
    ],
    products: [
        .library(name: "metal", targets: ["metal"]),
        .executable(name: "demo", targets: ["demo"]),
    ],
    targets: [
        .target(
            name: "metal",
            resources: [.process("Shaders")]
        ),
        .executableTarget(
            name: "demo",
            dependencies: ["metal"]
        ),
        .testTarget(
            name: "MetalTests",
            dependencies: ["metal"]
        ),
    ]
)
