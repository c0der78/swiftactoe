// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwifTacToe",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(
            name: "SwifTacToe",
            targets: ["SwifTacToe"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        //.package(url: "https://github.com/autozimu/Nanomsg.swift", from: "0.0.0")
        //.package(name: "NNG", url: "https://github.com/graphiclife/nng-swift.git", .branch("master")),
        .package(path: "./Nanomsg"),
        //.package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.0"),
        //.package(name: "TraceLog", url: "https://github.com/tonystone/tracelog", from: "5.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "SwifTacToe", dependencies: ["Nanomsg"])
        //.testTarget(
        //   name: "tests",
        //   dependencies: ["SwiftTacToe"],
        //   path: "Tests")
    ]
)
