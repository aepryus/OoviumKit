// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "OoviumKit",
	platforms: [
		.iOS(.v14), .macOS(.v10_15)
	],
    products: [
        .library(name: "OoviumKit", targets: ["OoviumKit"]),
    ],
    dependencies: [
		.package(url: "https://github.com/aepryus/OoviumEngine.git", branch: "master"),
    ],
    targets: [
        .target(
			name: "OoviumKit",
			dependencies: ["OoviumEngine"],
			resources: [
				.process("Resources/Fonts")
			]
		),
    ]
)
