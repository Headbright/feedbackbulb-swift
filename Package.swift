// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "FeedbackBulb",
  platforms: [
    .iOS(.v15),
    .macCatalyst(.v15),
    .macOS(.v13),
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "FeedbackBulb",
      targets: ["FeedbackBulb"]),
    .library(
      name: "FeedbackBulb.Toolbox",
      targets: ["FeedbackBulb.Toolbox"]),
  ],
  dependencies: [],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "FeedbackBulb"),
    .target(
      name: "FeedbackBulb.Toolbox",
      dependencies: ["FeedbackBulb"]),
    .testTarget(
      name: "FeedbackBulbTests",
      dependencies: ["FeedbackBulb"],
      resources: [
        .copy("Resources/2.png"),
        .copy("Resources/exampleForm")
      ]),
  ]
)
