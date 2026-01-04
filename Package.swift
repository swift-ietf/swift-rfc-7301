// swift-tools-version: 6.2

import PackageDescription

extension String {
    static let rfc7301: Self = "RFC 7301"
}

extension Target.Dependency {
    static var rfc7301: Self { .target(name: .rfc7301) }
    static var rfc8446: Self { .product(name: "RFC 8446", package: "swift-rfc-8446") }
    static var standards: Self { .product(name: "Standards", package: "swift-standards") }
    static var incits41986: Self { .product(name: "INCITS 4 1986", package: "swift-incits-4-1986") }
}

let package = Package(
    name: "swift-rfc-7301",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(name: .rfc7301, targets: [.rfc7301])
    ],
    dependencies: [
        .package(path: "../swift-rfc-8446"),
        .package(url: "https://github.com/swift-standards/swift-standards", from: "0.10.0"),
        .package(url: "https://github.com/swift-standards/swift-incits-4-1986", from: "0.6.3"),
    ],
    targets: [
        .target(
            name: .rfc7301,
            dependencies: [
                .rfc8446,
                .standards,
                .incits41986,
            ]
        ),
        .testTarget(
            name: .rfc7301.tests,
            dependencies: [
                .rfc7301
            ]
        ),
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
            .enableUpcomingFeature("MemberImportVisibility"),
        ]
}
