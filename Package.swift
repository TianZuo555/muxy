// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Muxy",
    platforms: [
        .macOS(.v14),
    ],
    dependencies: [
        .package(
            url: "https://github.com/migueldeicaza/SwiftTerm.git",
            from: "1.13.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "Muxy",
            dependencies: [
                .product(name: "SwiftTerm", package: "SwiftTerm"),
            ],
            path: "Muxy",
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)
