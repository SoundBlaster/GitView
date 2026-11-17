// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "WorkDomain",
    platforms: [.iOS(.v17), .macOS(.v15)],
    products: [.library(name: "WorkDomain", targets: ["WorkDomain"])],
    dependencies: [
        .package(url: "https://github.com/SoundBlaster/SpecificationCore.git", exact: "2.1.0")
    ],
    targets: [
        .target(name: "WorkDomain", dependencies: [
            .product(name: "SpecificationCore", package: "SpecificationCore")
        ]),
        .testTarget(name: "WorkDomainTests", dependencies: ["WorkDomain"])
    ]
)
