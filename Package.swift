// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Analytics",
  platforms: [
    .iOS(.v13), .tvOS(.v13)
  ],
  products: [
    .library(name: "Analytics", targets: ["Analytics"])
  ],
  targets: [
    .target(name: "Analytics", dependencies: []),
    .testTarget(name: "AnalyticsTests", dependencies: ["Analytics"])
  ]
)
