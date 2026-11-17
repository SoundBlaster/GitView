// swift-tools-version: 6.1
import PackageDescription
let package = Package(name: "WorkCache", platforms: [.iOS(.v17), .macOS(.v15)], products: [.library(name: "WorkCache", targets: ["WorkCache"])], targets: [.target(name: "WorkCache"), .testTarget(name: "WorkCacheTests", dependencies: ["WorkCache"])])
