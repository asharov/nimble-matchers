// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AsharovNimbleMatchers",
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(
      name: "AsharovNimbleMatchers",
      targets: ["AsharovNimbleMatchers"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "https://github.com/Quick/Nimble.git", from: "8.1.0"),
    .package(url: "https://github.com/Quick/Quick.git", from: "2.2.0")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(
      name: "AsharovNimbleMatchers",
      dependencies: ["Nimble"]),
    .testTarget(
      name: "AsharovNimbleMatchersTests",
      dependencies: ["AsharovNimbleMatchers", "Quick", "Nimble"]),
  ]
)
