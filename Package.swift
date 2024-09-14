// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlteredDeckFormat",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AlteredDeckFormat",
            targets: ["AlteredDeckFormat"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AlteredDeckFormat"),
        .testTarget(
            name: "AlteredDeckFormatTests",
            dependencies: ["AlteredDeckFormat"],
			resources: [
				.process("DeckLists/List1Offs.txt"),
				.process("DeckLists/List2Sets.txt"),
				.process("DeckLists/ListUniques.txt"),
				.process("DeckLists/ListYzmir.txt"),
				.process("DeckLists/TestExtdQty.txt"),
				.process("DeckLists/TestLongUniques.txt"),
				.process("DeckLists/TestManaOrb.txt"),
				.process("DeckLists/TestProducts.txt")]
        )
    ]
)
