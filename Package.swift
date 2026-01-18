// swift-tools-version: 6.2

import PackageDescription

extension String {
    static let rfc7301: Self = "RFC 7301"
}

extension Target.Dependency {
    static var rfc7301: Self { .target(name: .rfc7301) }
    static var rfc8446: Self { .product(name: "RFC 8446", package: "swift-rfc-8446") }
    static var standards: Self { .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions") }
    static var incits41986: Self { .product(name: "ASCII", package: "swift-ascii") }
}

let package = Package(
    name: "swift-rfc-7301",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(name: "RFC 7301", targets: ["RFC 7301"])
    ],
    dependencies: [
        .package(path: "../swift-rfc-8446"),
        .package(path: "../../swift-primitives/swift-standard-library-extensions"),
        .package(path: "../../swift-foundations/swift-ascii")
    ],
    targets: [
        .target(
            name: "RFC 7301",
            dependencies: [
                .rfc8446,
                .standards,
                .incits41986
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let existing = target.swiftSettings ?? []
    target.swiftSettings =
        existing + [
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility")
        ]
}
