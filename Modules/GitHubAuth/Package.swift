// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "GitHubAuth",
    platforms: [.iOS(.v17), .macOS(.v15)],
    products: [.library(name: "GitHubAuth", targets: ["GitHubAuth"])],
    targets: [
        .target(name: "GitHubAuth"),
        .testTarget(name: "GitHubAuthTests", dependencies: ["GitHubAuth"])
    ]
)
