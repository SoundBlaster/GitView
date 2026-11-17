// swift-tools-version: 6.1
import PackageDescription
let package = Package(name: "ProjectStore", platforms: [.iOS(.v17), .macOS(.v15)], products: [.library(name: "ProjectStore", targets: ["ProjectStore"])], targets: [.target(name: "ProjectStore"), .testTarget(name: "ProjectStoreTests", dependencies: ["ProjectStore"])])
